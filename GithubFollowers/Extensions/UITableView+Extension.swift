//
//  UITableView+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/19.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
