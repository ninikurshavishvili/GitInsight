//
//  DecorativeBarsView.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 17.04.26.
//

import SwiftUI


private struct DecorativeBarsView: View {
    var body: some View {
        HStack(spacing: 8) {
            Capsule().fill(Color.accentGreen.opacity(0.20)).frame(width: 34, height: 8)
            Capsule().fill(Color.accentGreen.opacity(0.40)).frame(width: 46, height: 8)
            Capsule().fill(Color.accentGreen.opacity(0.12)).frame(width: 26, height: 8)
            Capsule().fill(Color.accentGreen.opacity(0.30)).frame(width: 40, height: 8)
        }
        .padding(.vertical, 6)
        .accessibilityHidden(true)
    }
}
