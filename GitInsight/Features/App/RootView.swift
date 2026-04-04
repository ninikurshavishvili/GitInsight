//
//  RootView.swift
//  GitInsight
//

import SwiftUI


struct RootView: View {
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        Group {
            if authService.isAuthenticated {
                ProfileView(authService: authService)
            } else {
                LoginView()
            }
        }
        .task {
            await authService.loadUserIfTokenExists()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthService())
}
