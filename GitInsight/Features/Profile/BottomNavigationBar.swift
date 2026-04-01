//
//  BottomNavigationBar.swift
//  GitInsight
//

import SwiftUI

/// Bottom tab bar with Dashboard, Analytics, Goals, and Profile tabs.
/// The active tab is highlighted with the primary accent color.
struct BottomNavigationBar: View {

    @Binding var selectedTab: BottomNavigationBar.Tab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                TabItemView(tab: tab, isSelected: selectedTab == tab) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(AppTheme.Colors.surface)
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1),
            alignment: .top
        )
    }
}

// MARK: - Tab enum

extension BottomNavigationBar {
    enum Tab: CaseIterable {
        case dashboard, analytics, goals, profile

        var title: String {
            switch self {
            case .dashboard: return "Dashboard"
            case .analytics: return "Analytics"
            case .goals:     return "Goals"
            case .profile:   return "Profile"
            }
        }

        var icon: String {
            switch self {
            case .dashboard: return "square.grid.2x2.fill"
            case .analytics: return "chart.bar.fill"
            case .goals:     return "target"
            case .profile:   return "person.crop.circle.fill"
            }
        }
    }
}

// MARK: - Tab Item

private struct TabItemView: View {
    let tab: BottomNavigationBar.Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))

                Text(tab.title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
            }
            .foregroundStyle(
                isSelected
                    ? AppTheme.Colors.accent
                    : AppTheme.Colors.textSecondary.opacity(0.5)
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    BottomNavigationBar(selectedTab: .constant(.profile))
        .background(AppTheme.Colors.background)
}
