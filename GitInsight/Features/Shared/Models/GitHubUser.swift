//
//  GitHubUser.swift
//  GitInsight
//

import Foundation

/// A GitHub user profile decoded from the `/user` API endpoint.
struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let name: String?
    let avatar_url: URL?
    let bio: String?
    let public_repos: Int
    let followers: Int
    let following: Int
}
