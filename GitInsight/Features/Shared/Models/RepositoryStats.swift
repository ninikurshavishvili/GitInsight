//
//  RepositoryStats.swift
//  GitInsight
//

import Foundation

/// Aggregated repository and code-quality statistics shown on the Profile screen.
struct RepositoryStats {
    let totalCommits: Int
    let totalRepos: Int
    /// 0–100 stability / architecture score
    let architectureScore: Int
    /// Letter grade derived from the architecture score (e.g. "A", "B+")
    let architectureGrade: String
    /// Normalized 0–1 commit-activity values used for the sparkline mini-chart
    let sparklinePoints: [Double]
}
