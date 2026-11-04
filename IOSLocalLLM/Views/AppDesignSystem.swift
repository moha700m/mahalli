// Modified 2026 by justmgz: flat light "Sahl" panels.
import SwiftUI

// MARK: - Shared semantic design tokens

enum AppSpacing {
    static let xSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xLarge: CGFloat = 24
    static let xxLarge: CGFloat = 32
}

enum AppRadius {
    static let control: CGFloat = 12
    static let card: CGFloat = 16
    static let panel: CGFloat = 18
    static let composer: CGFloat = 20
}

// Assistant-specific rhythm. These names describe the density of the chat
// surface and keep its header, empty state, actions, and composer aligned.
enum AssistantSpacing {
    static let xxxSmall: CGFloat = 4
    static let xxSmall: CGFloat = 8
    static let xSmall: CGFloat = 12
    static let small: CGFloat = 16
    static let medium: CGFloat = 20
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
}

enum AssistantRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 22
    static let composer: CGFloat = 26
}

enum AppTypography {
    static let eyebrow: Font = .caption2.weight(.semibold)
    static let secondary: Font = .subheadline
    static let body: Font = .body
    static let title: Font = .title3.weight(.semibold)
}

enum AppStroke {
    static let hairline: CGFloat = 0.5
    static let regular: CGFloat = 1
}

enum AppShadow {
    static let panelColor = Color.black.opacity(0.05)
    static let panelRadius: CGFloat = 10
    static let panelY: CGFloat = 2
}

enum AppAnimation {
    static let quick = Animation.easeOut(duration: 0.16)
    static let state = Animation.spring(response: 0.36, dampingFraction: 0.86)
}

struct AppPanelBackground: ViewModifier {
    var cornerRadius: CGFloat = AppRadius.panel
    var cameraSafe = false

    @Environment(\.koduTheme) private var T

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background(shape.fill(T.surface))
            .overlay(shape.strokeBorder(T.rule, lineWidth: AppStroke.regular))
            .shadow(color: AppShadow.panelColor, radius: AppShadow.panelRadius, y: AppShadow.panelY)
    }
}

extension View {
    func appPanel(cornerRadius: CGFloat = AppRadius.panel, cameraSafe: Bool = false) -> some View {
        modifier(AppPanelBackground(cornerRadius: cornerRadius, cameraSafe: cameraSafe))
    }

    func minimumInteractiveSize() -> some View {
        frame(minWidth: 44, minHeight: 44)
    }
}

/// Keeps focus cleanup consistent for controls that remain mounted inside a TabView.
struct KeyboardDismissModifier<Trigger: Equatable>: ViewModifier {
    let trigger: Trigger

    func body(content: Content) -> some View {
        content.onChange(of: trigger) { _, _ in
            KeyboardDismiss.now()
        }
    }
}

extension View {
    func dismissKeyboardWhen<Trigger: Equatable>(_ trigger: Trigger) -> some View {
        modifier(KeyboardDismissModifier(trigger: trigger))
    }
}
