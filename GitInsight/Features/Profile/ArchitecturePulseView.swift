//
//  ArchitecturePulseView.swift
//  GitInsight
//

import SwiftUI

/// Card displaying architecture quality metrics and a sparkline commit chart.
struct ArchitecturePulseView: View {
    /// Stability score (0–100)
    let score: Int
    /// Letter grade, e.g. "A"
    let grade: String
    /// Normalized 0–1 values used for the mini sparkline chart
    let sparklinePoints: [Double]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header row
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Architecture Pulse")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    Text("Code quality and maintenance score")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    MetricChip(
                        value: "\(score)",
                        label: "Stability",
                        color: AppTheme.Colors.accent
                    )
                    MetricChip(
                        value: grade,
                        label: "Grade",
                        color: AppTheme.Colors.accentAlt
                    )
                }
            }

            // Sparkline chart
            SparklineView(points: sparklinePoints)
                .frame(height: 52)
        }
        .padding(16)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Metric Chip

private struct MetricChip: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.10))
        .clipShape(Capsule())
    }
}

// MARK: - Sparkline

private struct SparklineView: View {
    let points: [Double]

    var body: some View {
        ZStack {
            // Gradient fill under the line
            SparklineShape(points: points, closed: true)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.Colors.accent.opacity(0.3),
                            AppTheme.Colors.accent.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Stroke line
            SparklineShape(points: points, closed: false)
                .stroke(
                    AppTheme.Colors.accent,
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                )
        }
    }
}

// MARK: - Sparkline Shape

private struct SparklineShape: Shape {
    let points: [Double]
    /// When `true` the shape is closed at the bottom for use as a gradient fill.
    let closed: Bool

    func path(in rect: CGRect) -> Path {
        guard points.count > 1 else { return Path() }

        let step = rect.width / CGFloat(points.count - 1)
        let pts: [CGPoint] = points.enumerated().map { idx, val in
            CGPoint(
                x: CGFloat(idx) * step,
                y: rect.maxY - CGFloat(val) * rect.height
            )
        }

        var path = Path()
        path.move(to: pts[0])
        for i in 1..<pts.count {
            path.addLine(to: pts[i])
        }

        if closed {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }

        return path
    }
}

// MARK: - Preview

#Preview {
    ArchitecturePulseView(
        score: 94,
        grade: "A",
        sparklinePoints: [0.3, 0.5, 0.4, 0.7, 0.6, 0.9, 0.8, 1.0, 0.7, 0.85, 0.6, 0.75]
    )
    .padding()
    .background(AppTheme.Colors.background)
}
