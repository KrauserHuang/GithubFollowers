//
//  GFEmptyStateView.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/1.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        titleLabel.text = message
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(imageView)
        
        titleLabel.numberOfLines    = 3
        imageView.image             = UIImage(named: "empty-state-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            titleLabel.heightAnchor.constraint(equalToConstant: 200),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
}
