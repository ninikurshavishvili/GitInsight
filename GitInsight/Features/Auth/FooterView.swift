import SwiftUI

struct FooterView: View {
    var body: some View {
        Text("Built for developers who love clarity.")
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(Color(hex: 0x667085))
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        VStack {
            Spacer()
            FooterView()
                .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
    }
    .preferredColorScheme(.dark)
}
