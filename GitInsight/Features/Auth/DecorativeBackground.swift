import SwiftUI

struct DecorativeBackground: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: 0x7BDB80, alpha: 0.10))
                .frame(width: 300, height: 300)
                .offset(x: -160, y: -280)

            Circle()
                .fill(Color(hex: 0x61AFEF, alpha: 0.09))
                .frame(width: 240, height: 240)
                .offset(x: 170, y: 300)
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        DecorativeBackground()
    }
    .preferredColorScheme(.dark)
}
