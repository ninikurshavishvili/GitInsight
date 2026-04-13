import SwiftUI

struct TitleBlockView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("GitInsight")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0xDFE2EB))

            Text("Analyze repositories. Track contribution trends.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(hex: 0x98A2B3))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 6)
        }
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        TitleBlockView()
    }
    .preferredColorScheme(.dark)
}
