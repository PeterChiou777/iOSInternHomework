//
//  Pagination.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/1.
//

import Foundation

struct Pagination: Codable {
    let term: String
    let limit: Int
    var page: Int
    var noDataToLoad: Bool
}
