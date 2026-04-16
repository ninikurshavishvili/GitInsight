//
//  GitHubMark.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 16.04.26.
//

import SwiftUI

struct GitHubMark: View {
    var body: some View {
        // Simple SF Symbol fallback. (No WebKit; no SVG parsing.)
        // If you later add an asset named "github-mark", swap to Image("github-mark").
        Image(systemName: "circle.hexagongrid.fill")
            .font(.system(size: 20, weight: .semibold))
    }
}
