//
//  ContributionHeatmapView.swift
//  GitInsight
//

import SwiftUI

/// GitHub-style contribution heatmap rendered as a 52-week × 7-day grid.
///
/// - `data` is organised as `data[week][day]` with intensity values 0–4.
/// - A `LazyVGrid` with 52 fixed-width columns fills each day-row in order,
///   producing the familiar calendar layout (columns = weeks, rows = days).
struct ContributionHeatmapView: View {

    /// 2-D array `[week 0…51][day 0…6]` with intensity 0 (none) … 4 (heavy).
    let data: [[Int]]

    private let cellSize:   CGFloat = 10
    private let gap:        CGFloat = 3
    private let weekCount:  Int     = 52
    private let dayCount:   Int     = 7

    // Total grid width: weekCount cells + (weekCount − 1) gaps
    private var gridWidth: CGFloat {
        CGFloat(weekCount) * cellSize + CGFloat(weekCount - 1) * gap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Contributions")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                // 52 fixed columns; dayCount × weekCount cells fill dayCount rows automatically.
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(cellSize), spacing: gap), count: weekCount),
                    alignment: .leading,
                    spacing: gap
                ) {
                    // Iterate day-major so that all 52 cells of day 0 fill row 0, etc.
                    ForEach(0..<(dayCount * weekCount), id: \.self) { index in
                        let day  = index / weekCount
                        let week = index % weekCount
                        let level = levelAt(week: week, day: day)

                        RoundedRectangle(cornerRadius: 2)
                            .fill(cellColor(for: level))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
                .frame(width: gridWidth)
            }

            // Legend
            HStack(spacing: 5) {
                Text("Less")
                    .font(.system(size: 10))
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                ForEach(0..<5, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(cellColor(for: level))
                        .frame(width: cellSize, height: cellSize)
                }

                Text("More")
                    .font(.system(size: 10))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
        .padding(16)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }

    // MARK: - Helpers

    private func levelAt(week: Int, day: Int) -> Int {
        guard data.indices.contains(week),
              data[week].indices.contains(day) else { return 0 }
        return data[week][day]
    }

    private func cellColor(for level: Int) -> Color {
        switch level {
        case 0:  return Color.white.opacity(0.07)
        case 1:  return AppTheme.Colors.accent.opacity(0.25)
        case 2:  return AppTheme.Colors.accent.opacity(0.50)
        case 3:  return AppTheme.Colors.accent.opacity(0.75)
        default: return AppTheme.Colors.accent
        }
    }
}

// MARK: - Preview

#Preview {
    let mock: [[Int]] = (0..<52).map { _ in (0..<7).map { _ in Int.random(in: 0...4) } }
    return ContributionHeatmapView(data: mock)
        .padding()
        .background(AppTheme.Colors.background)
}
