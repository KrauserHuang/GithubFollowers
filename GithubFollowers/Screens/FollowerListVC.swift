//
//  FollowerListVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/28.
//

import UIKit

class FollowerListVC: UIViewController {
    
    
    
    enum Section {
        case main
    }
    
    var username: String!
    var collectionView: UICollectionView!
    var page                = 1
    var hasMoreFollowers    = true
    var isSearching         = false
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Follower>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Follower>
    
    private lazy var dataSource = configureDataSource()
    
    var followers: [Follower] = [] {
        didSet {
            updateSnapshot(on: followers, animated: true)
        }
    }
    
    var filteredFollowers: [Follower] = [] {
        didSet {
            updateSnapshot(on: filteredFollowers, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchController() {
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Please enter username"
//        searchController.obscuresBackgroundDuringPresentation = true //true: obscure(有遮罩), false: unobscure(無遮罩)
//        searchController.automaticallyShowsSearchResultsController = true
        navigationItem.searchController         = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationController?.navigationItem.searchController         = searchController
    }
    
    private func configureCollectionView() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
    }
    // MARK: - old way for collectionView layout
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width                     = view.bounds.width
        print("width:\(width)")
        let padding: CGFloat          = 12
        let itemInterSpacing: CGFloat = 10
        let availableWidth            = width - (padding * 2) - (itemInterSpacing * 2)
        print("availableWidth:\(availableWidth)")
        let itemWidth                 = availableWidth / 3
        print("itemWidth:\(itemWidth)")
        let flowLayout                = UICollectionViewFlowLayout()
        flowLayout.sectionInset       = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize           = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
    
    private func getFollowers() {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            
            guard let self = self else { return }
//            #warning("Remeber to call hideLoadingView")
            self.hideLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: "This user doesn't have any followers. Go follow them 😀.",
                                                in: self.view)
                    }
                }
//                dump(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
            
            cell.avatarImageView.image = cell.avatarImageView.placeholderImage
            cell.set(follower: itemIdentifier)
            
            return cell
        }
        return dataSource
    }
    
    private func updateSnapshot(on followers: [Follower], animated: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
    // MARK: - new way to create collectionView layout
    private func createLayout() -> UICollectionViewLayout {
        //item
        let itemSize            = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item                = NSCollectionLayoutItem(layoutSize: itemSize)
        let padding: CGFloat    = 12
        item.contentInsets      = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        //group
        let itemWidth           = CGFloat((view.bounds.width - (padding * 6))/3 + 40)
        let groupSize           = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(itemWidth))
        let group               = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //section & layout
        let section             = NSCollectionLayoutSection(group: group)
        let layout              = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
// MARK: - CollectionView Delegate
extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers else { return }
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.height
        
//        print("==========Start==========")
//        print("offsetY:         \(offsetY)")
//        print("contentHeight:   \(contentHeight)")
//        print("height:          \(height)")
//        print("paginationHeight:\(contentHeight - height)")
//        print("==========End==========")
        
        if offsetY > contentHeight - height {
            page += 1
            getFollowers()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let userInfoVC              = UserInfoVC()
        userInfoVC.username         = follower.login
        let navigationController    = UINavigationController(rootViewController: userInfoVC)
        
        present(navigationController, animated: true)
    }
}
// MARK: - Search Delegate(SearchResultUpdating/SearchBar)
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //從 searchBar 上的 text 去抓取要過濾的 followers，並且 searchBar 一定要輸入文字
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            updateSnapshot(on: followers, animated: true)
            return
        }
        filteredFollowers = followers.filter { $0.login.contains(filter) } // didSet 將會直接執行 updateSnapshot
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateSnapshot(on: followers, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateSnapshot(on: followers, animated: true)
    }
}
