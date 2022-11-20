//
//  UICollectionViewFlowLayout+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/18.
//

import UIKit

extension UICollectionViewFlowLayout {
    // MARK: - old way for collectionView layout
    func createThreeColumnFlowLayout(in view: UIView) {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12                                                //外部間隔
        let itemInterSpacing: CGFloat   = 10                                                //內部間距
        let availableWidth              = width - (padding * 2) - (itemInterSpacing * 2)    //item可使用長度
        let itemWidth                   = availableWidth / 3
        
        sectionInset                    = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        itemSize                        = CGSize(width: itemWidth, height: itemWidth + 40)
        
        print("width:\(width)")
        print("availableWidth:\(availableWidth)")
        print("itemWidth:\(itemWidth)")
    }
}
