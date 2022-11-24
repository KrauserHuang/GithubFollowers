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
    // convenience initializer 的基本條件就是要先有 designated initializer，這裡是指 GFButton，所以遵從了 designated initializer 就可以使用他的屬性、方法(configure)
    convenience init(backgroundColor: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: backgroundColor, title: title, systemImageName: systemImageName)
    }
    //設定這個客製化按鈕基本元素
    private func configure() {
//        layer.cornerRadius    = 10
//        titleLabel?.font      = UIFont.preferredFont(forTextStyle: .headline)
//        setTitleColor(.white, for: .normal)
        
        //======================= iOS15 =======================
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func set(color: UIColor, title: String, systemImageName: String) {
//        self.backgroundColor = backgroundColor
//        setTitle(title, for: .normal)
        
        //======================= iOS15 =======================
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}
