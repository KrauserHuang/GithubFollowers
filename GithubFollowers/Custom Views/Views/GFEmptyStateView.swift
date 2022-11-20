//
//  GFEmptyStateView.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/1.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let titleLabel  = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let imageView   = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        titleLabel.text = message
    }
    
    private func configure() {
        addSubviews(titleLabel, imageView)
        
        titleLabel.numberOfLines    = 3
        imageView.image             = Images.emptyStateLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //在較小機型特別改動 UI 元件的 constraint
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: labelCenterYConstant),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            titleLabel.heightAnchor.constraint(equalToConstant: 200),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: logoBottomConstant)
        ])
    }
}
