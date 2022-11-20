//
//  Follower.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/30.
//

import Foundation

struct Follower: Codable {
//    let uuid = UUID().uuidString
    var login: String
    var avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl
    }
}

extension Follower: Hashable {}
