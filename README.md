<div dir="rtl">

# محلّي (Mahalli)

مساعد ذكاء اصطناعي يعمل **بالكامل على جهاز الآيفون** — بدون حساب وبدون إرسال بياناتك لأي خادم.
واجهة عربية أولاً (من اليمين لليسار)، بتصميم فاتح وبسيط.

**المزايا:** محادثة مع نماذج محلية (MLX و llama.cpp)، محادثة صوتية وإملاء (whisper.cpp)،
تنزيل وإدارة النماذج من Hugging Face، توليد الصور على الجهاز، قاعدة معرفة (RAG) للمستندات،
خادم API محلي متوافق مع OpenAI / Anthropic / Ollama، والاقتران مع Mac.

</div>

---

**Mahalli** is an on-device AI assistant for iPhone with an Arabic-first, RTL,
light/minimal UI. Copyright (c) 2026 justmgz.

It is derived from the MIT-licensed
[ios-local-llm](https://github.com/mesutcydev/ios-local-llm) project — see
[NOTICE](NOTICE) and [LICENSE](LICENSE). It is not affiliated with the upstream
authors and does not use their names, icons, or artwork.

## Build

Requirements: macOS with **Xcode 26**, `xcodegen`, `cmake`.

```bash
git clone --recurse-submodules <this repo>
cd mahalli
./scripts/build_native_frameworks.sh   # llama.cpp + whisper.cpp XCFrameworks
xcodegen generate                      # creates Mahalli.xcodeproj
open Mahalli.xcodeproj                 # scheme: Mahalli
```

There are no CocoaPods dependencies. For a device build, set your own team in
Xcode; bundle id is `com.justmgz.mahalli` (share extension
`com.justmgz.mahalli.share`, app group `group.com.justmgz.mahalli.shared`).

### CI: unsigned IPA

`.github/workflows/build-ipa.yml` builds an unsigned `Mahalli-unsigned.ipa` on
a `macos-26` runner (submodules → native frameworks → xcodegen → `xcodebuild
archive CODE_SIGNING_ALLOWED=NO` → `Payload/` zip) and uploads it as an
artifact. Run it from the Actions tab (workflow_dispatch) or by pushing to
`main`. Re-sign the IPA with your own certificate before installing.

## License

MIT — see [LICENSE](LICENSE) (upstream copyright retained) and [NOTICE](NOTICE).
Bundled font: IBM Plex Sans Arabic, SIL OFL 1.1.
