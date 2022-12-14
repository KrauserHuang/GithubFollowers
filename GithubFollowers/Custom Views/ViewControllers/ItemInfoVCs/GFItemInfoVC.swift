//
//  GFItemInfoVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/10.
//

import UIKit

class GFItemInfoVC: UIViewController {
    //作為parentVC, 這邊不是先做設定，而是把排版、加入畫面這種repetitive動作先給寫好，在依各個childVC去做設定
    let stackView       = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton    = GFButton()
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundView()
        configureActionButton()
        configureStackView()
        layoutUI()
    }
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor    = .secondarySystemBackground
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }
    @objc func didTapActionButton(_ sender: UIButton) {} //點擊動作這邊不做設定，交由各個 childVC 去做
    
    private func configureStackView() {
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
        
        stackView.axis          = .horizontal
        stackView.distribution  = .equalSpacing
    }
    
    private func layoutUI() {
        view.addSubviews(stackView, actionButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
