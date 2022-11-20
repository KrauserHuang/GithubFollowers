//
//  UITableView+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/19.
//

import UIKit

extension UITableView {
    func removeExcessCells() { //移除 tableView 下面多餘空白 cell 的線
        tableFooterView = UIView(frame: .zero)
    }
}
