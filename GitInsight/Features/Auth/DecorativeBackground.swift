//
//  DecorativeBackground.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 16.04.26.
//

import SwiftUI


struct DecorativeBackground: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentGreen.opacity(0.08))
                .frame(width: 420, height: 420)
                .blur(radius: 90)
                .offset(x: -140, y: -240)

            Circle()
                .fill(Color.secondaryBlue.opacity(0.07))
                .frame(width: 340, height: 340)
                .blur(radius: 80)
                .offset(x: 160, y: 280)
        }
        .allowsHitTesting(false)
    }
}
