//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/2.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: UIViewController {
    
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    var itemViews: [UIView] = []
    let dateLabel           = GFBodyLabel(textAlignment: .center)
    
    var username: String!
    weak var delegate: UserInfoVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        getUserInfo()
        layoutUI()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    private func configureViewController() {
        title                               = username
        view.backgroundColor                = .systemBackground
        let doneButton                      = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem   = doneButton
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { result in
            switch result {
            case .success(let user):
//                dump(user)
                DispatchQueue.main.async {
                    self.configureUIElements(for: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func configureUIElements(for user: User) {
        
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.addChildVC(from: repoItemVC, to: self.itemViewOne)
        self.addChildVC(from: followerItemVC, to: self.itemViewTwo)
        self.addChildVC(from: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "Github since \(user.createdAt.convertDateToDisplayString())"
    }
    
    private func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func addChild(from childVC: UIViewController, to containerView: UIView) {
        /*
         將第二個 VC 當做第一個 VC 的 children(通常作為客製化使用)
         1. addChild
         2. addChild's view
         3. define it's(child.view) frame
         4.
         */
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoVC: GFItemInfoVCDelegate {
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        openSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞.", buttonTitle: "So sad")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
