//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/2.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title                               = username
        view.backgroundColor                = .systemBackground
        
        let doneButton                      = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem   = doneButton
        
        NetworkManager.shared.getUserInfo(for: username) { result in
            switch result {
            case .success(let user):
                dump(user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
