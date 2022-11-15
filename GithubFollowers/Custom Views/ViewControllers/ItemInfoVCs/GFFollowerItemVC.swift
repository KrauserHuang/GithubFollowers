//
//  GFFollowerItemVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/10.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(with: .followers, withCount: user.followers)
        itemInfoViewTwo.set(with: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Follower")
    }
    
    override func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapGetFollowers(for: user)
    }
}
