//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/10.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate?
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
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
        itemInfoViewOne.set(with: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(with: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Github Profile", systemImageName: "person")
    }
    
    override func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapGithubProfile(for: user)
    }
}
