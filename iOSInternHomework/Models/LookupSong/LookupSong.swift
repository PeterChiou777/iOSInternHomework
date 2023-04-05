//
//  LookupSong.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/2.
//

import Foundation

struct LookupSongResult: Codable {
    let resultCount: Int
    let results: LookupSongItems
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
}

typealias LookupSongItems = [LookupSongItem]

struct LookupSongItem: Codable {
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkUrl100: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let previewUrl: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case collectionName = "collectionName"
        case trackName = "trackName"
        case artworkUrl100 = "artworkUrl100"
        case artistViewUrl = "artistViewUrl"
        case collectionViewUrl = "collectionViewUrl"
        case previewUrl = "previewUrl"
        case releaseDate = "releaseDate"
    }
}
