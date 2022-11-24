//
//  UIViewController+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/29.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) { //在 UIViewController 顯示 Alert
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    /// 你說這個嗎
    func showLoadingView() {                    //通常會放在 Networking 前，故不用特別放進 DispatchQueue
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.alpha             = 0.0
        containerView.backgroundColor   = .systemBackground
        
        UIView.animate(withDuration: 0.25) {    //透明變微暗
            containerView.alpha = 0.8
        }
        
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.center    = containerView.center
        activityIndicatorView.color     = .systemGreen
        
        activityIndicatorView.startAnimating()
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {    //微暗變透明
                containerView.alpha = 0.0
            } completion: { _ in                    //動畫結束後，將畫面移出 ViewController
                containerView.removeFromSuperview()
                containerView = nil
            }
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) { //顯示空白狀態
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func addChildVC(from child: UIViewController, to containerView: UIView) { //將子類別嵌入至父類別，第二個 VC 當做第一個 VC 的 children(通常作為客製化使用)
        addChild(child)                         //1.加入子類別
        containerView.addSubview(child.view)    //2. 加入畫面
        child.view.frame = containerView.bounds //3. 決定畫面範圍
        child.didMove(toParent: self)           //4. 通知父類別
    }
    
    func removeChildVC() {                      //將子類別從父類別移除
        guard parent != nil else { return }     //確認父類別是否存在
        
        willMove(toParent: nil)                 //3. 通知父類別，子類別準備移除
        view.removeFromSuperview()              //2. 子畫面從父畫面移除
        removeFromParent()                      //1. 子類別從父類別移除
    }
    
    func openSafariVC(with url: URL) { //開起Safari
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
