//
//  LanguageStat.swift
//  GitInsight
//

import SwiftUI

/// A single programming language and its share of a developer's codebase.
struct LanguageStat: Identifiable {
    let id = UUID()
    /// Display name, e.g. "TypeScript"
    let name: String
    /// Usage percentage in the range 0–100
    let percentage: Double
    /// Representative color shown in the progress bar and dot indicator
    let color: Color
}
