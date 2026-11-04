// Copyright (c) 2026 justmgz
// SPDX-License-Identifier: MIT
//
// Registers the bundled IBM Plex Sans Arabic faces (SIL Open Font License
// 1.1, see Resources/Fonts/OFL.txt) at launch so `KoduTheme.sans/display`
// can resolve them. Registration is best-effort: when a file is missing the
// theme silently falls back to the system font, which also covers Arabic.

import CoreText
import Foundation

enum SahlFonts {
    static let files = [
        "IBMPlexSansArabic-Light",
        "IBMPlexSansArabic-Regular",
        "IBMPlexSansArabic-Medium",
        "IBMPlexSansArabic-SemiBold",
        "IBMPlexSansArabic-Bold",
    ]

    static func registerBundledFonts() {
        for name in files {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
