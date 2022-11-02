//
//  CacheManager.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/1.
//

import Foundation

struct CacheManager {
    static let shared = CacheManager()
//    private init() {}
    
    let cache = NSCache<NSString, AnyObject>()
}
