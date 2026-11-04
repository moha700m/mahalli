#!/usr/bin/env bash
# Build the iOS 18+ Mahalli workbench and package a profile-less,
# re-signer-ready IPA. MLX, llama.cpp, Voice, Models and the share extension
# stay in this product; the optional Core AI runtime is a separate iOS 27 build.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

XCODE="${XCODE_BETA_PATH:-$(xcode-select -p | sed 's|/Contents/Developer$||')}"
export DEVELOPER_DIR="$XCODE/Contents/Developer"
OUT_DIR="${1:-$HOME/Desktop}"
VERSION="$(awk -F'"' '/CFBundleShortVersionString:/ { print $2; exit }' project.yml)"
BUILD="$(awk -F'"' '/CURRENT_PROJECT_VERSION:/ { print $2; exit }' project.yml)"
ARCHIVE="$ROOT/build/Mahalli-$VERSION-$BUILD.xcarchive"
IPA="$OUT_DIR/Mahalli-sideload-entitled-$VERSION-$BUILD.ipa"
LATEST="$OUT_DIR/Mahalli-sideload-entitled-latest.ipa"
APP="$ARCHIVE/Products/Applications/Mahalli.app"
MAIN_ENTITLEMENTS="$ROOT/IOSLocalLLM/IOSLocalLLM.entitlements"
EXT_ENTITLEMENTS="$ROOT/IOSLocalLLMShareExtension/IOSLocalLLMShareExtension.entitlements"

die() { echo "error: $*" >&2; exit 1; }

[[ -d "$XCODE" ]] || die "Xcode not found at $XCODE"
[[ -n "$VERSION" && -n "$BUILD" ]] || die "could not resolve version/build"

echo "=== 1/8  Generate Xcode project + CocoaPods workspace"
xcodegen generate >/dev/null
pod install >/dev/null

echo "=== 2/8  Verify catalog and all direct model links"
./scripts/verify_zoo_catalog.sh >/dev/null
python3 scripts/verify_zoo_downloads.py >/dev/null

echo "=== 3/8  Archive the full workbench unsigned"
rm -rf "$ARCHIVE"
mkdir -p build "$OUT_DIR"
xcodebuild archive \
  -workspace Mahalli.xcworkspace \
  -scheme Mahalli \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  > build/sideload-archive.log 2>&1 \
  || { tail -80 build/sideload-archive.log; die "archive failed"; }
[[ -d "$APP" ]] || die "archive contains no Mahalli.app"

echo "=== 4/8  Reject unsafe FoundationModels imports"
./scripts/verify_foundationmodels_symbols.sh "$APP" >/dev/null \
  || { ./scripts/verify_foundationmodels_symbols.sh "$APP" || true; die "dyld symbol preflight failed"; }

echo "=== 5/8  Verify archive identity and required resources"
PLIST="$APP/Info.plist"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$PLIST")" == "com.justmgz.mahalli" ]] \
  || die "wrong bundle id"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleDisplayName' "$PLIST")" == "Mahalli" ]] \
  || die "wrong display name"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$PLIST")" == "$VERSION" ]] \
  || die "wrong version"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$PLIST")" == "$BUILD" ]] \
  || die "wrong build"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :MinimumOSVersion' "$PLIST")" == "18.0" ]] \
  || die "wrong minimum OS"
[[ -f "$APP/PrivacyInfo.xcprivacy" ]] || die "privacy manifest missing"
[[ -d "$APP/PlugIns/MahalliShare.appex" ]] || die "share extension missing"
[[ -d "$APP/Frameworks/llama.framework" ]] || die "llama framework missing"
[[ -d "$APP/Frameworks/whisper.framework" ]] || die "whisper framework missing"
if otool -L "$APP/Mahalli" | grep -q 'CoreAI.framework'; then
  die "CoreAI framework must not be linked in the iOS 18 build"
fi

python3 scripts/collect_sideload_notices.py "$APP" build/sideload-archive.log

echo "=== 6/8  Ad-hoc sign with the exact app + extension entitlements"
rm -f "$IPA" "$LATEST"
./scripts/package_adhoc_sideloadable_ipa.sh \
  "$APP" "$IPA" "$MAIN_ENTITLEMENTS" "$EXT_ENTITLEMENTS"
cp "$IPA" "$LATEST"

echo "=== 7/8  Verify final Payload, signatures, flags and entitlements"
VERIFY="$(mktemp -d "${TMPDIR:-/tmp}/mahalli-ipa.XXXXXX")"
trap 'rm -rf "$VERIFY"' EXIT
unzip -tq "$IPA" >/dev/null || die "IPA zip integrity failed"
unzip -q "$IPA" -d "$VERIFY"
ROOT_ENTRIES="$(find "$VERIFY" -mindepth 1 -maxdepth 1 -print | wc -l | tr -d ' ')"
[[ "$ROOT_ENTRIES" == "1" && -d "$VERIFY/Payload" ]] || die "IPA root must contain only Payload/"
SIGNED_APP="$VERIFY/Payload/Mahalli.app"
SIGNED_EXT="$SIGNED_APP/PlugIns/MahalliShare.appex"
codesign --verify --deep --strict "$SIGNED_APP" || die "final app signature invalid"
[[ -f "$SIGNED_APP/PrivacyInfo.xcprivacy" ]] || die "final privacy manifest missing"
for key in UIFileSharingEnabled LSSupportsOpeningDocumentsInPlace; do
  [[ "$(/usr/libexec/PlistBuddy -c "Print :$key" "$SIGNED_APP/Info.plist")" == "true" ]] \
    || die "$key is not true"
done
ACTUAL="$VERIFY/app-entitlements.plist"
codesign -d --entitlements :- "$SIGNED_APP" > "$ACTUAL" 2>/dev/null
for key in \
  com.apple.developer.kernel.increased-memory-limit \
  com.apple.developer.kernel.extended-virtual-addressing \
  com.apple.security.application-groups \
  com.apple.developer.icloud-container-identifiers; do
  /usr/libexec/PlistBuddy -c "Print :$key" "$ACTUAL" >/dev/null 2>&1 \
    || die "entitlement missing from final binary: $key"
done
EXT_ACTUAL="$VERIFY/extension-entitlements.plist"
codesign -d --entitlements :- "$SIGNED_EXT" > "$EXT_ACTUAL" 2>/dev/null
/usr/libexec/PlistBuddy -c 'Print :com.apple.security.application-groups:0' "$EXT_ACTUAL" \
  | grep -q '^group.com.justmgz.mahalli.shared$' \
  || die "share extension app-group entitlement mismatch"

echo "=== 8/8  Artifact"
SIZE="$(stat -f %z "$IPA")"
SHA="$(shasum -a 256 "$IPA" | awk '{print $1}')"
echo "IPA: $IPA"
echo "LATEST: $LATEST"
echo "SIZE: $SIZE bytes"
echo "SHA256: $SHA"
echo "APP ENTITLEMENTS:"
plutil -p "$ACTUAL" | sed 's/^/  /'
echo "EXTENSION ENTITLEMENTS:"
plutil -p "$EXT_ACTUAL" | sed 's/^/  /'
