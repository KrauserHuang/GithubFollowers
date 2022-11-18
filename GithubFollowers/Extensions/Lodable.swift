//
//  Lodable.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/18.
//

import UIKit

protocol Lodable {
    var containerView: UIView! { get set }
    
    func showLoadingView()
    func hideLoadingView()
    func showEmptyStateView(with message: String, in view: UIView)
}

// extend protocol Lodable where 'Self' is of type 'UIViewController'
extension Lodable where Self: UIViewController {
    mutating func showLoadingView() {
        containerView = UIView(frame: view.bounds) //背景半黑
        view.addSubview(containerView)
        
        containerView.alpha             = 0.0
        containerView.backgroundColor   = .systemBackground
        
        UIView.animate(withDuration: 0.25) { [self] in
            containerView.alpha = 0.8
        }
        
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.center    = containerView.center
        activityIndicatorView.color     = .systemGreen
        
        activityIndicatorView.startAnimating()
    }
    
//    mutating func hideLoadingView() {
//        DispatchQueue.main.async { [self] in
//            UIView.animate(withDuration: 0.25) { [self] in
//                containerView.alpha = 0.0
//            } completion: { _ in
//                containerView.removeFromSuperview()
//                containerView = nil
//            }
//        }
//    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
