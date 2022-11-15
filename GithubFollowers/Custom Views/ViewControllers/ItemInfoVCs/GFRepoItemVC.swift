//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/10.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(with: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(with: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapGithubProfile(for: user)
    }
}
