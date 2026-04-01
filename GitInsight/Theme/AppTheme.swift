//
//  AppTheme.swift
//  GitInsight
//

import SwiftUI

/// App-wide design tokens: colors, corner radii, and typographic styles.
enum AppTheme {

    // MARK: - Colors

    enum Colors {
        /// Page background — #10141a
        static let background    = Color(hex: 0x10141A)
        /// Card / surface — #181c22
        static let surface       = Color(hex: 0x181C22)
        /// Primary green accent — #7bdb80
        static let accent        = Color(hex: 0x7BDB80)
        /// Secondary blue accent — #afc6ff
        static let accentAlt     = Color(hex: 0xAFC6FF)
        /// Primary text — #dfe2eb
        static let textPrimary   = Color(hex: 0xDFE2EB)
        /// Secondary / muted text — #becaba
        static let textSecondary = Color(hex: 0xBECABA)
        /// Subtle border / outline — #3f4a3d
        static let outline       = Color(hex: 0x3F4A3D)
        /// On-primary (text on green button) — #00390e
        static let onPrimary     = Color(hex: 0x00390E)
    }

    // MARK: - Corner radius

    enum Radius {
        static let card:  CGFloat = 16
        static let small: CGFloat = 12
        static let chip:  CGFloat = 8
    }
}

// MARK: - Color hex initializer (module-wide)

extension Color {
    /// Creates a `Color` from a 24-bit hex value like `0x7BDB80`.
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8)  & 0xFF) / 255
        let b = Double( hex        & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
