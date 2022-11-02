//
//  GFAlertView.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/29.
//

import UIKit

class GFAlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.borderWidth  = 2
        layer.borderColor  = UIColor.white.cgColor
        backgroundColor    = .systemBackground
    }
}
