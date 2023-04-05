//
//  SearchSongResult.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/3/26.
//

import Foundation

struct SearchSongResult: Codable {
    let resultCount: Int
    let results: SearchSongItems
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
}

typealias SearchSongItems = [SearchSongItem]

struct SearchSongItem: Codable {
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkUrl100: String?
    
    enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case trackName = "trackName"
        case artworkUrl100 = "artworkUrl100"
    }
}
