//
//  UIView+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/18.
//

import UIKit

extension UIView {
    // variadic parameters
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
