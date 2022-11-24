//
//  User.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/30.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let followersUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: Date // decoder 將轉成 iso8601
//    let createdAt: String // decoder 將轉成 iso8601
}
