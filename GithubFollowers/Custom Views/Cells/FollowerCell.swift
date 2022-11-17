//
//  FollowerCell.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/31.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
//    let aavatarImageView = GFAlertView()
    let usernameLabel   = GFTitleLabel(textAlignment: .center, fontSize: 16)
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with follower: Follower) {
        usernameLabel.text = follower.login
//        avatarImageView.downloadImage(from: follower.avatarUrl)
        avatarImageView.setImage(from: follower.avatarUrl)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
//            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
