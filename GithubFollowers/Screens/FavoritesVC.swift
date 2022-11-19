//
//  FavoritesVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/27.
//

import UIKit

class MyFavoriteDataSource: UITableViewDiffableDataSource<Section, Follower> {
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "This is section: \(section)"
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let favorite  = self.itemIdentifier(for: indexPath) else { return }

        var snapshot = self.snapshot()
        snapshot.deleteItems([favorite])
        self.apply(snapshot)

        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
//            self.presentGFAlertOnMainThread(title: "Something went wrong with the deletion", message: error.rawValue, buttonTitle: "OK")
        }
    }
}

class FavoritesVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView           = UITableView()
        tableView.delegate      = self
        tableView.rowHeight     = 80
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
        tableView.removeExcessCells()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//    typealias DataSource    = UITableViewDiffableDataSource<Section, Follower>
    typealias DataSource    = MyFavoriteDataSource
    typealias Snapshot      = NSDiffableDataSourceSnapshot<Section, Follower>
    
    private lazy var dataSource = configureDataSource()
    
    var favorites: [Follower] = [] {
        didSet {
            updateSnapshot(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configreTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
    }
    
    private func configreTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func getFavorites() {
        showLoadingView()
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            self.hideLoadingView()
            switch result {
            case .success(let favorites):
                guard !favorites.isEmpty else {
                    self.tableView.isHidden = true
                    self.showEmptyStateView(with: "There is no any follower\n Please add some =]", in: self.view)
                    return
                }
                self.favorites = favorites
                self.tableView.isHidden = false
                self.view.bringSubviewToFront(self.tableView)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something wrong with your favorites list", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
            
            cell.set(with: itemIdentifier)
            
            return cell
        }
        return dataSource
    }
    
    private func updateSnapshot(animated: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let favorite  = dataSource.itemIdentifier(for: indexPath) else { return }
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                //當沒有錯誤時，favorite 會從 PersistenceManager 移除完成後，再從 UI 面下手，取得目前的 snapshot，刪除該 favorite 後再 apply 到 dataSource
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems([favorite])
                self.dataSource.apply(snapshot)
                return
            }
            self.presentGFAlertOnMainThread(title: "Something went wrong with the deletion", message: error.rawValue, buttonTitle: "OK")
        }
    }
}

extension FavoritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favorite  = dataSource.itemIdentifier(for: indexPath) else { return }
        let destVC          = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
