//
//  UITableViewCell+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/31.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
