//
//  MusicSearchCell.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/1.
//

import UIKit
import Reusable
import SDWebImage

class MusicSearchCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var singerName: UILabel!
    var albumCoverURL: String? {
        didSet {
            setupAlbumCover()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupAlbumCover() {
        albumCover.layer.cornerRadius = 15
        guard let url = albumCoverURL else { return }
        guard let albumURL = URL(string: url) else { return }
        //圖片快取
        albumCover.sd_setImage(with: albumURL)
    }
    
    func reset(){
        albumCover.image = nil
        songTitle.text = nil
        albumTitle.text = nil
        singerName.text = nil
    }
}
