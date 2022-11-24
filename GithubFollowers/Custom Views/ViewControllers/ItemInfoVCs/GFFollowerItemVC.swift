//
//  GFFollowerItemVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/10.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate?
    
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(with: .followers, withCount: user.followers)
        itemInfoViewTwo.set(with: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Follower", systemImageName: "person.3")
    }
    
    override func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapGetFollowers(for: user)
    }
}
