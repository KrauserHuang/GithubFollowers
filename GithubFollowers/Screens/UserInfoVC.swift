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
        
        title = username
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
