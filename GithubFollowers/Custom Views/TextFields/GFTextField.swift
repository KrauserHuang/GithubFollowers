//
//  GFTextField.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/28.
//

import UIKit

class GFTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label // 最基本的顏色設置(dark mode: white/light mode: black)
        tintColor = .label // blinking cursor(游標顏色)
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        //自動因輸入文字超出而縮小文字大小，但設定最小只能縮小到12
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
//        autocorrectionType = .no
        spellCheckingType = .no
        
        placeholder = "Enter a username"
    }
}
