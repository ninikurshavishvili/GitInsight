//
//  GitInsightApp.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 30.03.26.
//

import SwiftUI

@main
struct GitInsightApp: App {

    @StateObject private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
        }
    }
}
