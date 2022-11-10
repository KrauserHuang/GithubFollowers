//
//  GFButton.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/28.
//

import UIKit

class GFButton: UIButton {
    //只要是客製化，都需要提供初始化動作
    override init(frame: CGRect) {
        // super 是指 GFButton 的父類別，也就是 UIButton
        //初始化父類別後，就可以使用父類別所有的屬性、方法
        super.init(frame: frame)
        configure()
    }
    // storyboard在用的？？
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //可設定背景色/文字的初始化動作
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    //設定這個客製化按鈕基本元素
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius    = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font      = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
