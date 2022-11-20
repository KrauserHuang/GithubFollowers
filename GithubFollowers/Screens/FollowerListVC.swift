//
//  FollowerListVC.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/28.
//

import UIKit

enum Section {
    case main
}

class FollowerListVC: UIViewController {
    
    var username: String!
    var collectionView: UICollectionView!
    var page                        = 1
    var hasMoreFollowers            = true
    var isSearching                 = false
    var lastScrollPosition: CGFloat = 0
    var isLoadingMoreFollower       = false
    
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
    //每次進入這個畫面就要初始化的動作(指定username/title這個動作應該由VC自己本身做)
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username   = username
        title           = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton                       = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem   = addButton
    }
    
    private func configureSearchController() {
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
//        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Please enter username"
//        searchController.obscuresBackgroundDuringPresentation = true //true: obscure(有遮罩), false: unobscure(無遮罩)
//        searchController.automaticallyShowsSearchResultsController = true
        navigationItem.searchController         = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationController?.navigationItem.searchController         = searchController
    }
    
    private func configureCollectionView() {
        
        //使用 UICollectionViewFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.createThreeColumnFlowLayout(in: view)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        
        //使用 CompositionalLayout
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollower = true
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            
            guard let self = self else { return }
            self.hideLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
            }
            
            self.isLoadingMoreFollower = false
        }
    }
    
    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }  //當 followers 數量小於100，代表該使用者已經沒更多 followers
        self.followers.append(contentsOf: followers)                // append(contentsOf:)可放 sequence
        
        if self.followers.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "This user doesn't have any followers. Go follow them 😀.", in: self.view)
                self.navigationItem.searchController?.searchBar.isHidden = true
            }
        }
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
            
            cell.avatarImageView.image = cell.avatarImageView.placeholderImage
            cell.set(with: itemIdentifier)
            
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
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.hideLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(with: user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong...", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func addUserToFavorites(with user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl) //將該名使用者轉成 Follower 型別(因為接下來要把他加進我的最愛)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🥳.", buttonTitle: "Hurray!")
                return
            }
            self.presentGFAlertOnMainThread(title: "Something went wrong...", message: error.rawValue, buttonTitle: "OK")
        }
    }
}
// MARK: - CollectionView Delegate
extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers, !isLoadingMoreFollower else { return } //有更多使用者，並且不在載入中
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
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let userInfoVC              = UserInfoVC()
        userInfoVC.username         = follower.login
        userInfoVC.delegate         = self
        let navigationController    = UINavigationController(rootViewController: userInfoVC)
        
        present(navigationController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {  //將停止的位置當作初始 y 座標
        lastScrollPosition = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {          //用來決定畫面是往上捲動或往下捲動
        if lastScrollPosition < scrollView.contentOffset.y {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else if lastScrollPosition > scrollView.contentOffset.y { //往上捲動，searchBar要顯示
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
}
// MARK: - Search Delegate(SearchResultUpdating/SearchBar)
//extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //從 searchBar 上的 text 去抓取要過濾的 followers，並且 searchBar 一定要輸入文字
        //這一段在你按下 searchBar 的 cancel 按鈕時也會執行
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            updateSnapshot(on: followers, animated: true)                   //點 cancel 被清空搜尋內容時，需要還原最初始 followers 內容
            return
        }
        filteredFollowers = followers.filter { $0.login.contains(filter) }  // didSet 將會直接執行 updateSnapshot
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        updateSnapshot(on: followers, animated: true)
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        updateSnapshot(on: followers, animated: true)
//    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
//        collectionView.setContentOffset(.zero, animated: true)
//        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        updateSnapshot(on: followers)
        
        if isSearching {
            navigationItem.searchController?.searchBar.text = ""
            navigationItem.searchController?.isActive = false
            navigationItem.searchController?.dismiss(animated: false)
            isSearching = false
        }
        
        getFollowers(username: username, page: page)
    }
}
