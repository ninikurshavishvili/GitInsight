//
//  DisclaimerView.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 17.04.26.
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        Text("GitInsight will access your public GitHub activity, including repository names, commit timestamps, and contribution statistics to build your analytics dashboard.")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color.textMuted.opacity(0.9))
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .frame(maxWidth: 320)
            .padding(.top, 2)
    }
}
