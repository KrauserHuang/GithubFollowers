//
//  UICollectionViewCell+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/31.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
