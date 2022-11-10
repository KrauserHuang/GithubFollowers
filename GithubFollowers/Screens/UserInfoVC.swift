//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/2.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    var itemViews: [UIView] = []
    
    var username: String!

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
                    self.addChildVC(from: GFUserInfoHeaderVC(user: user), to: self.headerView)
//                    self.addChild(from: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo]
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
        
        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight)
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
