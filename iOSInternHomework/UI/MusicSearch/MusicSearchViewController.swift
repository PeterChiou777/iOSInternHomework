//
//  ViewController.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/3/19.
//

import UIKit
import Reusable
import RxSwift
import Moya
import SDWebImage
import NVActivityIndicatorView

class MusicSearchViewController: UIViewController, StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard.Main
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    var searchSongItems = SearchSongItems() {
        didSet{
            guard collectionView != nil else {
                ErrorHelper.track()
                return }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var pagination: Pagination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView()
        setupSearchController()
        setupCollectionView()
    }
    
    func callSearchAPI(pagination: Pagination) {
        guard pagination.noDataToLoad != true else { return }
        
        let request = SearchAPI.GetSongResult(pagination: pagination)
        
        API.shared.requestAutoMap(request)
            .subscribe(onSuccess: { [weak self] searchResult in
                guard searchResult.resultCount != 0 else {
                    self?.loadingView.stopAnimating()
                    self?.pagination?.noDataToLoad = true
                    return
                }
                self?.searchSongItems += searchResult.results
                self?.loadingView.stopAnimating()
                
            }, onFailure: { error in
                ErrorHelper.handleMoyaError(error: error)
            }).disposed(by: self.disposeBag)
    }
    
    func clearSearchResult() {
        self.pagination = nil
        self.searchSongItems = []
    }
}

//MARK: - SearchBar
extension MusicSearchViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //使用者按下搜尋後呼叫API
        loadingView.startAnimating()
        clearSearchResult()
        guard let term = searchBar.text else { return }
        self.pagination = Pagination(term: term, limit: 20, page: 0, noDataToLoad: false)
        guard let searchPagination = self.pagination else {
            ErrorHelper.track()
            return }
        callSearchAPI(pagination: searchPagination)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        clearSearchResult()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchResult()
    }
    
    func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.placeholder = "Search for songs"
        navigationItem.searchController = searchController
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.gray], for: .normal)
    }
    
    //如API資料回來速度太慢 先給使用者看轉圈圈
    func setupLoadingView() {
        loadingView.type = .circleStrokeSpin
        loadingView.color = .black
    }
}
//MARK: - CollectionView
extension MusicSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchSongItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchSongItem = self.searchSongItems[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MusicSearchCell
        cell.reset()
        cell.albumCoverURL = searchSongItem.artworkUrl100
        cell.songTitle.text = searchSongItem.trackName
        cell.singerName.text = searchSongItem.artistName
        cell.albumTitle.text = searchSongItem.collectionName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (searchSongItems.count - 1) {
            self.pagination?.page += 1
            guard let searchPagination = pagination else {
                ErrorHelper.track()
                return }
            callSearchAPI(pagination: searchPagination)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //使用者按下歌曲後跳轉到詳細頁面
        let vc = SongInfoViewController.instantiate()
        vc.callLookupAPI(lookupID: searchSongItems[indexPath.item].trackId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: MusicSearchCell.self)
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 3
        collectionLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        collectionView.collectionViewLayout = collectionLayout
    }
}

extension MusicSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
}
