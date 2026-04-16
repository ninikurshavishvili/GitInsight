//
//  FooterView.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 16.04.26.
//

import SwiftUI

 struct FooterView: View {
    var body: some View {
        Text("Built for developers by developers")
            .font(.system(size: 10, weight: .medium))
            .textCase(.uppercase)
            .tracking(1.6)
            .foregroundStyle(Color.textMuted.opacity(0.35))
            .frame(maxWidth: .infinity, alignment: .center)
            .accessibilityLabel("Built for developers by developers")
    }
}

