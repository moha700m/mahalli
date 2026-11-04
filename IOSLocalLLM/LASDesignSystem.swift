// Modified 2026 by justmgz: re-tokenised for the light "Sahl" design system.
import SwiftUI

enum LASDesignTokens {
    static let micro: CGFloat = 4
    static let tight: CGFloat = 8
    static let row: CGFloat = 12
    static let component: CGFloat = 16
    static let pageInset: CGFloat = 20
    static let cardPadding: CGFloat = 20
    static let section: CGFloat = 24

    static let majorRadius: CGFloat = 20
    static let cardRadius: CGFloat = 16
    static let tileRadius: CGFloat = 14
    static let controlRadius: CGFloat = 12

    static let hairline = Color.black.opacity(0.07)
    static let pageTop = Color(red: 0.973, green: 0.973, blue: 0.965)
    static let pageBottom = Color(red: 0.973, green: 0.973, blue: 0.965)
    static let terminalBackground = Color(red: 0.067, green: 0.094, blue: 0.086)
}

/// Plain paper page background.
struct LASPageBackground: View {
    var body: some View {
        SahlBackdrop()
    }
}

struct LASCardModifier: ViewModifier {
    let radius: CGFloat
    let padding: CGFloat

    @Environment(\.koduTheme) private var T

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .glassSurface(.card, cornerRadius: radius)
    }
}

extension View {
    func lasCard(
        radius: CGFloat = LASDesignTokens.cardRadius,
        padding: CGFloat = LASDesignTokens.cardPadding
    ) -> some View {
        modifier(LASCardModifier(radius: radius, padding: padding))
    }
}

struct LASSectionLabel: View {
    let title: LocalizedStringKey
    var trailing: String?
    var trailingColor: Color = .secondary
    var foreground: Color = .secondary

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(foreground)
            Spacer(minLength: LASDesignTokens.tight)
            if let trailing {
                Text(verbatim: trailing)
                    .font(.caption2.weight(.semibold).monospaced())
                    .foregroundStyle(trailingColor)
            }
        }
    }
}

struct LASDetailHeader<Trailing: View>: View {
    let title: LocalizedStringKey
    let dark: Bool
    /// Headers embedded at a navigation root (e.g. a tab) have nothing to
    /// pop back to; hide the chevron there instead of rendering a button
    /// whose `dismiss()` is a guaranteed no-op.
    var showsBack: Bool = true
    private let trailing: Trailing

    @Environment(\.dismiss) private var dismiss

    init(
        _ title: LocalizedStringKey,
        dark: Bool = false,
        showsBack: Bool = true,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.dark = dark
        self.showsBack = showsBack
        self.trailing = trailing()
    }

    var body: some View {
        ZStack {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(dark ? Color.white : Color.primary)
                .lineLimit(1)

            HStack {
                if showsBack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .contentShape(Circle())
                    }
                    .buttonStyle(LASHeaderIconButtonStyle(dark: dark))
                    .accessibilityLabel("Back")
                }

                Spacer()

                trailing
                    .frame(width: 44, height: 44)
            }
        }
        .frame(minHeight: 56)
        .padding(.horizontal, LASDesignTokens.pageInset)
    }
}

struct LASHeaderIconButtonStyle: ButtonStyle {
    let dark: Bool

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if dark {
                configuration.label
                    .foregroundStyle(Color.white)
                    .background(
                        Color.white.opacity(configuration.isPressed ? 0.20 : 0.13),
                        in: Circle()
                    )
                    .overlay {
                        Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
                    }
            } else {
                configuration.label
                    .foregroundStyle(Color.primary)
                    .background(Color.black.opacity(configuration.isPressed ? 0.08 : 0.04), in: Circle())
            }
        }
        .scaleEffect(configuration.isPressed ? 0.96 : 1)
        .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

struct LASEmptyHeaderSlot: View {
    var body: some View {
        Color.clear
            .frame(width: 44, height: 44)
            .accessibilityHidden(true)
    }
}

struct LASSearchField: View {
    @Binding var text: String
    let prompt: LocalizedStringKey

    var body: some View {
        HStack(spacing: LASDesignTokens.tight) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.secondary)

            TextField(prompt, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, LASDesignTokens.component)
        .frame(minHeight: 52)
        .glassSurface(.card, cornerRadius: LASDesignTokens.controlRadius)
    }
}

struct LASPrimaryButtonStyle: ButtonStyle {
    @Environment(\.koduTheme) private var T

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, LASDesignTokens.component)
            .frame(minHeight: 44)
            .background(
                T.accent.opacity(configuration.isPressed ? 0.82 : 1),
                in: RoundedRectangle(cornerRadius: LASDesignTokens.controlRadius, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct LASSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.tint)
            .padding(.horizontal, LASDesignTokens.component)
            .frame(minHeight: 44)
            .background(
                Color.secondary.opacity(configuration.isPressed ? 0.17 : 0.10),
                in: RoundedRectangle(cornerRadius: LASDesignTokens.controlRadius, style: .continuous)
            )
    }
}

struct LASMetricTile: View {
    let title: String
    let value: String
    let detail: String
    let symbol: String

    var body: some View {
        HStack(spacing: LASDesignTokens.row) {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: LASDesignTokens.micro) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(verbatim: value)
                    .font(.subheadline.weight(.semibold).monospaced())
                    .lineLimit(1)
                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(LASDesignTokens.row)
        .frame(minHeight: 88)
        .glassSurface(.listRow, cornerRadius: LASDesignTokens.tileRadius)
    }
}
