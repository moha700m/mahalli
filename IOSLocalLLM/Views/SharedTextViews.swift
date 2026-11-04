import SwiftUI
import UIKit

// Shared text/markdown helpers (extracted from the removed camera analysis panel).

// MARK: - StreamingCaret
// Blinking caret shown while FastVLM is generating.

struct StreamingCaret: View {
    @State private var on = true
    @Environment(\.koduTheme) private var T

    var body: some View {
        Rectangle()
            .fill(T.ink)
            .frame(width: 7, height: 14)
            .opacity(on ? 1 : 0)
            .onAppear {
                withAnimation(.linear(duration: 0.6).repeatForever(autoreverses: true)) {
                    on.toggle()
                }
            }
    }
}

// MARK: - BlinkModifier
// Subtle pulse for status dots while a stream is in progress.

struct BlinkModifier: ViewModifier {
    @State private var faded = false
    func body(content: Content) -> some View {
        content
            .opacity(faded ? 0.35 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                    faded.toggle()
                }
            }
    }
}

// MARK: - ShareSheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - MarkdownTextView (unchanged — kept here for co-location)

struct MarkdownTextView: View {
    let markdown: String
    @Environment(\.koduTheme) private var T

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in block }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var blocks: [AnyView] {
        let lines = markdown.components(separatedBy: "\n")
        var views: [AnyView] = []
        var codeLines: [String] = []
        var inCodeBlock = false

        for line in lines {
            if line.hasPrefix("```") {
                if inCodeBlock {
                    let code = codeLines.joined(separator: "\n")
                    views.append(AnyView(
                        Text(code)
                            .font(T.mono(11))
                            .foregroundColor(T.ink)
                            .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 6).fill(T.surface))
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(T.rule, lineWidth: 1))
                    ))
                    codeLines = []; inCodeBlock = false
                } else { inCodeBlock = true }
            } else if inCodeBlock {
                codeLines.append(line)
            } else {
                views.append(AnyView(renderLine(line)))
            }
        }
        return views
    }

    @ViewBuilder
    private func renderLine(_ line: String) -> some View {
        if line.hasPrefix("# ") {
            Text(String(line.dropFirst(2)))
                .font(T.display(20, .semibold))
                .tracking(-0.5)
                .foregroundColor(T.ink)
                .padding(.top, 8)
        } else if line.hasPrefix("## ") {
            Text(String(line.dropFirst(3)))
                .font(T.display(16, .semibold))
                .foregroundColor(T.ink)
                .padding(.top, 6)
        } else if line.hasPrefix("### ") {
            Text(String(line.dropFirst(4)))
                .font(T.sans(13, .semibold))
                .foregroundColor(T.ink)
        } else if line.hasPrefix("**") && line.hasSuffix("**") && line.count > 4 {
            Text(String(line.dropFirst(2).dropLast(2)))
                .font(T.sans(13, .semibold))
                .foregroundColor(T.ink)
        } else if line.hasPrefix("- ") {
            HStack(alignment: .top, spacing: 6) {
                Text("·").foregroundColor(T.ink3)
                Text(String(line.dropFirst(2)))
                    .font(T.sans(13))
                    .foregroundColor(T.ink2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        } else if line.hasPrefix("> ") {
            Text(String(line.dropFirst(2)))
                .font(T.mono(11))
                .foregroundColor(T.ink2)
                .padding(.leading, 10)
                .overlay(Rectangle().fill(T.warn.opacity(0.6)).frame(width: 2), alignment: .leading)
        } else if line.isEmpty {
            Spacer().frame(height: 4)
        } else {
            Text(line)
                .font(T.sans(13))
                .foregroundColor(T.ink2)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
