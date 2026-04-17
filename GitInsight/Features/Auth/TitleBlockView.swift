//
//  TitleBlockView.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 17.04.26.
//

import SwiftUI

private struct TitleBlockView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("GitInsight")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .tracking(-1.0)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.accentGreen, Color.accentGreen2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Track and analyze your GitHub activity")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.textMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: 300)
        }
    }
}
