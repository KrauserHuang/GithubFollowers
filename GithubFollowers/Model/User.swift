//
//  User.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/30.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var htmlUrl: String
    var followersUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var followers: Int
    var following: Int
    var createdAt: String
}
