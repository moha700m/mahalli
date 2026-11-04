import SwiftUI

// MARK: - LegalAcceptanceView
// Full-screen gate shown on first launch and whenever the legal version is
// bumped. The user must accept Privacy + EULA + AI Disclaimer before the
// main app UI is reachable.
//
// Design: a guided review flow. Each document is a tactile glass card that
// flips from a chevron to a checked state once read; a progress strip in the
// pinned action bar counts the reviews; the primary action stays disabled
// (and explains itself) until all four documents are done.

struct LegalAcceptanceView: View {

    @StateObject private var legal = LegalAcceptanceManager.shared
    @ObservedObject private var loc = LocalizationService.shared
    @State private var didReadPrivacy = false
    @State private var didReadEULA    = false
    @State private var didReadDisclaimer = false
    @State private var didReadDeviceSafety = false

    @State private var showPrivacy = false
    @State private var showEULA    = false
    @State private var showDisclaimer = false
    @State private var showDeviceSafety = false
    @Environment(\.koduTheme) private var T
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var entered = false

    let onAccepted: () -> Void

    private var readCount: Int {
        [didReadPrivacy, didReadEULA, didReadDisclaimer, didReadDeviceSafety]
            .filter { $0 }.count
    }

    private var canContinue: Bool { readCount == 4 }

    var body: some View {
        ZStack {
            LiquidPinkBackdrop()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    headerView
                    reviewCard(index: 0,
                               title: "privacy policy",
                               subtitle: "how your data is (not) handled",
                               icon: "lock.shield",
                               tint: T.good,
                               accepted: $didReadPrivacy,
                               openAction: { showPrivacy = true })
                    reviewCard(index: 1,
                               title: "open-source license & safety",
                               subtitle: "MIT license and important notices",
                               icon: "doc.text",
                               tint: T.accent,
                               accepted: $didReadEULA,
                               openAction: { showEULA = true })
                    reviewCard(index: 2,
                               title: "ai output disclaimer",
                               subtitle: "ai can be wrong — always verify",
                               icon: "exclamationmark.triangle",
                               tint: T.warn,
                               accepted: $didReadDisclaimer,
                               openAction: { showDisclaimer = true })
                    reviewCard(index: 3,
                               title: "device safety notice",
                               subtitle: "on-device ai heats the device",
                               icon: "thermometer.medium",
                               tint: T.bad,
                               accepted: $didReadDeviceSafety,
                               openAction: { showDeviceSafety = true })

                    Text(loc.t("By tapping Agree, you confirm that you have read and accepted all four documents above. You can review them any time in Settings → Legal."))
                        .font(T.sans(11.5))
                        .foregroundColor(T.ink2)
                        .lineSpacing(2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 6)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 16)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom, spacing: 0) { actionBar }
        }
        .onAppear { entered = true }
        .onChange(of: canContinue) { _, done in
            if done { HapticManager.impact(.soft) }
        }
        // Each doc counts as "read" ONLY after the user scrolls to the end and
        // taps "I have read this" (onReadConfirmed) — not merely on dismiss.
        .sheet(isPresented: $showPrivacy) {
            LegalDocumentView(
                title: loc.t("Privacy Policy"),
                markdown: LegalDocuments.privacyPolicy,
                externalURL: LegalDocuments.privacyPolicyURL,
                onReadConfirmed: { didReadPrivacy = true }
            )
        }
        .sheet(isPresented: $showEULA) {
            LegalDocumentView(
                title: loc.t("License & Safety"),
                markdown: LegalDocuments.eula,
                externalURL: LegalDocuments.eulaURL,
                onReadConfirmed: { didReadEULA = true }
            )
        }
        .sheet(isPresented: $showDisclaimer) {
            LegalDocumentView(
                title: loc.t("AI Disclaimer"),
                markdown: LegalDocuments.aiDisclaimer,
                onReadConfirmed: { didReadDisclaimer = true }
            )
        }
        .sheet(isPresented: $showDeviceSafety) {
            LegalDocumentView(
                title: loc.t("Device Safety"),
                markdown: LegalDocuments.deviceSafetyNotice,
                onReadConfirmed: { didReadDeviceSafety = true }
            )
        }
    }

    // MARK: - Sub-views

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            KWordmark(name: "Mahalli", logoAsset: "app_logo_small")
            VStack(alignment: .leading, spacing: 4) {
                KCaption(text: loc.t("first launch"))
                Text(loc.t("Before\nyou start."))
                    .font(T.display(34, .semibold))
                    .tracking(-1.2)
                    .foregroundColor(T.ink)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 8)
            Text(loc.t("Review the four documents below. Tap each to read — the button unlocks when all four are done."))
                .font(T.sans(13))
                .foregroundColor(T.ink2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(entered ? 1 : 0)
        .offset(y: entered ? 0 : 8)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.4), value: entered)
    }

    @ViewBuilder
    private func reviewCard(
        index: Int,
        title: String,
        subtitle: String,
        icon: String,
        tint: Color,
        accepted: Binding<Bool>,
        openAction: @escaping () -> Void
    ) -> some View {
        let isRead = accepted.wrappedValue
        Button(action: openAction) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(tint)
                    .frame(width: 34, height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(tint.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    KMono(text: loc.t(title), size: 13, weight: .semibold, color: T.ink)
                    KMono(text: loc.t(subtitle), size: 10, color: T.ink2)
                }

                Spacer(minLength: 8)

                Image(systemName: isRead ? "checkmark.circle.fill" : "chevron.right")
                    .font(.system(size: isRead ? 17 : 12, weight: .medium))
                    .foregroundColor(isRead ? T.good : T.ink3)
                    .animation(reduceMotion ? nil
                        : .spring(response: 0.32, dampingFraction: 0.62), value: isRead)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .kGlass(cornerRadius: 12, fallbackFill: T.surface, fallbackStroke: T.rule)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isRead ? T.good.opacity(0.45) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(KTactileButtonStyle())
        .accessibilityHint(isRead ? loc.t("Reviewed") : loc.t("Opens the document"))
        .opacity(entered ? 1 : 0)
        .offset(y: entered ? 0 : 10)
        .animation(reduceMotion ? nil
            : .easeOut(duration: 0.42).delay(0.05 + 0.045 * Double(index)),
            value: entered)
    }

    private var actionBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                ForEach(0..<4) { index in
                    Capsule()
                        .fill(index < readCount ? T.good : T.rule)
                        .frame(height: 3)
                        .frame(maxWidth: .infinity)
                }
                Text(String(format: loc.t("%d of 4"), readCount))
                    .font(T.mono(11))
                    .foregroundStyle(readCount == 4 ? T.good : T.ink2)
                    .padding(.leading, 6)
            }
            .animation(reduceMotion ? nil : .easeOut(duration: 0.3), value: readCount)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(String(format: loc.t("%d of 4 documents reviewed"), readCount))

            KPrimaryButton(
                label: loc.t(canContinue ? "Agree and continue" : "Review all four to continue"),
                systemImage: canContinue ? "checkmark" : nil,
                trailing: canContinue ? "↵" : nil,
                action: accept,
                disabled: !canContinue
            )
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .background(T.bg)
    }

    private func accept() {
        legal.acceptLegal()
        legal.acceptDisclaimer()
        legal.acceptDeviceSafety()
        HapticManager.impact(.medium)
        onAccepted()
    }
}
