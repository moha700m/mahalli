// Copyright (c) 2026 justmgz
// SPDX-License-Identifier: MIT
//
// "Sahl" (سهل — "easy / plain") surface primitives.
//
// Replaces the upstream translucent Liquid Glass renderer and the pink
// ambient backdrop with a flat, opaque, light-first look: solid white
// cards on a warm paper canvas, hairline borders, a soft single shadow,
// and no blur/refraction. The modifier names (`kClearGlass`, `kGlass`,
// `kGlassCapsule`, `glassSurface`, `KGlassContainer`, `shimmer`) are kept
// so existing call sites compile unchanged, but they now render flat.

import SwiftUI

// MARK: - Surface roles

enum GlassRole {
    case hero, card, listRow, button, capsule, icon, badge, toolbarButton, tabBar

    var radius: CGFloat {
        switch self {
        case .hero: return 20
        case .card, .listRow: return 16
        case .button: return 14
        case .capsule, .badge: return 999
        case .icon, .toolbarButton: return 12
        case .tabBar: return 24
        }
    }

    var interactive: Bool {
        switch self {
        case .button, .capsule, .icon, .badge, .toolbarButton, .tabBar: return true
        default: return false
        }
    }

    /// Whether the surface gets the (very soft) elevation shadow.
    var elevated: Bool {
        switch self {
        case .hero, .card, .tabBar: return true
        default: return false
        }
    }
}

private struct SahlSurfaceModifier<S: InsettableShape>: ViewModifier {
    @Environment(\.koduTheme) private var T
    let shape: S
    let role: GlassRole
    let fill: Color?
    let stroke: Color?

    func body(content: Content) -> some View {
        content
            .background(
                shape
                    .fill(fill ?? T.surface)
                    .shadow(
                        color: role.elevated && !T.isDark ? Color.black.opacity(0.04) : .clear,
                        radius: 8, x: 0, y: 2
                    )
            )
            .overlay(
                shape.strokeBorder(stroke ?? T.rule, lineWidth: 1)
                    .allowsHitTesting(false)
            )
    }
}

/// Treats `.clear` as "not provided" so legacy call sites that pass
/// `fallbackFill: .clear` still get a readable opaque surface.
private func provided(_ color: Color) -> Color? {
    color == .clear ? nil : color
}

extension View {
    func glassSurface(
        _ role: GlassRole = .card,
        cornerRadius: CGFloat? = nil
    ) -> some View {
        modifier(SahlSurfaceModifier(
            shape: RoundedRectangle(cornerRadius: cornerRadius ?? role.radius, style: .continuous),
            role: role, fill: nil, stroke: nil
        ))
    }

    /// Flat surface in an arbitrary shape. `tint` (when given) is used as a
    /// soft fill for "active" states; otherwise `fallbackFill` / theme surface.
    func kClearGlass<S: InsettableShape>(
        in shape: S,
        tint: Color? = nil,
        interactive: Bool = false,
        fallbackFill: Color = .clear,
        fallbackStroke: Color = .clear
    ) -> some View {
        modifier(SahlSurfaceModifier(
            shape: shape,
            role: interactive ? .button : .capsule,
            fill: tint.map { $0.opacity(0.12) } ?? provided(fallbackFill),
            stroke: provided(fallbackStroke)
        ))
    }

    func kGlass(
        cornerRadius: CGFloat = 10,
        tint: Color? = nil,
        fallbackFill: Color = .clear,
        fallbackStroke: Color = .clear
    ) -> some View {
        modifier(SahlSurfaceModifier(
            shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            role: .card,
            fill: tint.map { $0.opacity(0.12) } ?? provided(fallbackFill),
            stroke: provided(fallbackStroke)
        ))
    }

    func kGlassCapsule(
        tint: Color? = nil,
        fallbackFill: Color = .clear,
        fallbackStroke: Color = .clear
    ) -> some View {
        modifier(SahlSurfaceModifier(
            shape: Capsule(),
            role: .capsule,
            fill: tint.map { $0.opacity(0.12) } ?? provided(fallbackFill),
            stroke: provided(fallbackStroke)
        ))
    }
}

// MARK: - Container (kept for source compatibility; plain stack now)

struct KGlassContainer<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(spacing: CGFloat = 0, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View { content() }
}

// MARK: - Loading shimmer (respects Reduce Motion)

extension View {
    func shimmer(
        isActive: Bool = true,
        duration: Double = 1.4,
        intensity: Double = 0.55
    ) -> some View {
        modifier(SahlShimmerModifier(isActive: isActive, duration: duration, intensity: intensity))
    }
}

private struct SahlShimmerModifier: ViewModifier {
    let isActive: Bool
    let duration: Double
    let intensity: Double
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var dim = false

    func body(content: Content) -> some View {
        content
            .opacity(isActive && !reduceMotion ? (dim ? 1 - intensity * 0.5 : 1) : 1)
            .onAppear { start() }
            .onChange(of: isActive) { _, _ in start() }
    }

    private func start() {
        guard isActive, !reduceMotion else { dim = false; return }
        withAnimation(.easeInOut(duration: duration / 2).repeatForever(autoreverses: true)) {
            dim = true
        }
    }
}

// MARK: - Page background

/// Plain paper page background (replaces the upstream ambient backdrop).
struct SahlBackdrop: View {
    @Environment(\.koduTheme) private var T

    var body: some View {
        T.bg
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

// MARK: - Card / pill primitives

struct SahlCard<Content: View>: View {
    @Environment(\.koduTheme) private var T
    let radius: CGFloat
    let intensity: Intensity
    let content: Content

    enum Intensity { case lo, med, hi }

    init(radius: CGFloat = 16, intensity: Intensity = .med, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.intensity = intensity
        self.content = content()
    }

    var body: some View {
        let fill: Color = {
            switch intensity {
            case .hi:  return T.surface
            case .med: return T.surface
            case .lo:  return T.surface2
            }
        }()
        content.kGlass(cornerRadius: radius, fallbackFill: fill, fallbackStroke: T.rule)
    }
}

struct SahlPill<Content: View>: View {
    @Environment(\.koduTheme) private var T
    let active: Bool
    let content: Content

    init(active: Bool = false, @ViewBuilder content: () -> Content) {
        self.active = active
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .frame(minHeight: 36)
            .kClearGlass(
                in: Capsule(),
                fallbackFill: active ? T.accent : T.surface,
                fallbackStroke: active ? T.accent : T.rule
            )
            .foregroundColor(active ? .white : T.ink)
    }
}

struct SahlIconButton<Content: View>: View {
    @Environment(\.koduTheme) private var T
    let size: CGFloat
    let action: () -> Void
    let label: Content

    init(size: CGFloat = 44, action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.size = max(size, 44)   // 44pt minimum touch target
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(action: action) {
            label
                .frame(width: size, height: size)
                .kClearGlass(in: Circle(), interactive: true,
                             fallbackFill: T.surface, fallbackStroke: T.rule)
                .foregroundColor(T.ink)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct KActiveBadge: View {
    @Environment(\.koduTheme) private var T
    let text: String

    init(_ text: String = "ACTIVE") { self.text = text }

    var body: some View {
        Text(text)
            .font(T.sans(10, .semibold))
            .foregroundColor(T.accent)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Capsule().fill(T.accentSoft))
    }
}
