//
//  UIView+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/18.
//

import UIKit

extension UIView {
    /*
     -- variadic parameters --
     定義任意數量的參數型別(UIView)，其參數會被當作該型別陣列來做處理
     ex:
     addSubviews(a, b, c, d) --> 他能吃所有該型別的"參數"
     */
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    /*
     與上面 function 功能一樣，差別在你在使用這個 function 帶入的參數需為陣列型態
     ex:
     let array = [a, b, c, d]
     addSubviews(array) --> 他只吃該型別的"陣列"
     */
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
