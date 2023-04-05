//
//  SongInfoViewController.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/2.
//

import UIKit
import Reusable
import RxSwift
import Moya
import NVActivityIndicatorView

class SongInfoViewController: UIViewController, StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard.Main
    
    enum ActionType: Int {
        case Singer = 0
        case Album = 1
        case Play = 2
    }
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var singerTitle: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var playButton: UIImageView!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    var lookupID: Int?
    
    var lookupSongItem: LookupSongItem? {
        didSet {
            guard lookupSongItem != nil else {
                ErrorHelper.track()
                return
            }
            
            DispatchQueue.main.async {
                self.reloadSongInfo()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabelActions()
        setupLoadingView()
    }
    
    func callLookupAPI(lookupID: Int?) {
        guard let lookupID = lookupID else {
            ErrorHelper.track()
            return }
        
        let request = LookupAPI.GetLookupResult(id: lookupID)
        
        API.shared.requestAutoMap(request)
            .subscribe(onSuccess: { [weak self] searchResult in
                self?.lookupSongItem = searchResult.results[0]
                
            }, onFailure: { error in
                ErrorHelper.handleMoyaError(error: error)
            }).disposed(by: self.disposeBag)
    }
    
    func reloadSongInfo() {
        songTitle.text = lookupSongItem?.trackName
        singerTitle.text = lookupSongItem?.artistName
        albumTitle.text = lookupSongItem?.collectionName
        playButton.image = UIImage(systemName: "play.circle")
        
        if let dateString = lookupSongItem?.releaseDate {
            releaseDate.text = DateHelper.getYYYYMMddFormant(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", dateString: dateString)
        }
        
        guard var urlString = lookupSongItem?.artworkUrl100 else {
            ErrorHelper.track()
            return }
        if let range = urlString.range(of: "/100x100bb.jpg") {
            urlString.replaceSubrange(range, with: "/600x600bb.jpg")
        }
        guard let albumURL = URL(string: urlString) else {
            ErrorHelper.track()
            return }
        albumCover.layer.cornerRadius = 30
        //圖片快取
        albumCover.sd_setImage(with: albumURL)
        loadingView.stopAnimating()
    }
    
    
}

extension SongInfoViewController {
    
    //如API資料回來速度太慢 先給使用者看轉圈圈
    func setupLoadingView() {
        loadingView.type = .circleStrokeSpin
        loadingView.color = .black
        loadingView.startAnimating()
    }
    
    func setupLabelActions() {
        let singerTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let albumTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let playGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        singerTitle.isUserInteractionEnabled = true
        albumTitle.isUserInteractionEnabled = true
        playButton.isUserInteractionEnabled = true
        
        singerTitle.addGestureRecognizer(singerTapGesture)
        albumTitle.addGestureRecognizer(albumTapGesture)
        playButton.addGestureRecognizer(playGesture)
        
        singerTapGesture.view?.tag = ActionType.Singer.rawValue
        albumTapGesture.view?.tag = ActionType.Album.rawValue
        playGesture.view?.tag = ActionType.Play.rawValue
        
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let webVC = WebViewURLViewController.instantiate()
        guard let actionType = ActionType(rawValue: sender.view?.tag ?? 0) else { return }
        
        switch actionType {
        case .Singer:
            webVC.url = lookupSongItem?.artistViewUrl
        case .Album:
            webVC.url = lookupSongItem?.collectionViewUrl
        case .Play:
            webVC.url = lookupSongItem?.previewUrl
        }
        navigationController?.pushViewController(webVC, animated: true)
    }

}
