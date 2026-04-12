import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        Text("By continuing, you agree to GitInsight's Terms and Privacy Policy.")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color(hex: 0x98A2B3))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.top, 2)
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        DisclaimerView()
            .padding()
    }
    .preferredColorScheme(.dark)
}
