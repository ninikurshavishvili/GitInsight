//
//  LoginView.swift
//  GitInsight
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ZStack {
            

            DecorativeBackground()

            VStack(spacing: 28) {
                LogoClusterView()
                TitleBlockView()
                DecorativeBarsView()

                GitHubLoginButton {
                    authService.signInWithGitHub()
                }

                DisclaimerView()
                SecurityBadgeRow()

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 420)
            .frame(maxHeight: .infinity, alignment: .center)

            VStack {
                Spacer()
                FooterView()
                    .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService())
        .preferredColorScheme(.dark)
}
