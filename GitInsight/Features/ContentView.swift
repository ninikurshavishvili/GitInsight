//
//  ContentView.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 30.03.26.
//

import SwiftUI

/// Legacy entry-point kept for compatibility; the app now launches `RootView` directly.
struct ContentView: View {
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        RootView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
}

