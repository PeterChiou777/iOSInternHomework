//
//  SearchAPI.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/3/25.
//

import Moya

enum SearchAPI {
    
    struct GetSongResult: AppleAPITargetType, AccessTokenAuthorizable {
        var authorizationType: Moya.AuthorizationType? {
            return .bearer
        }
        
        typealias ResponseType = SearchSongResult
        
        var parametersDic: [String: Any] {
            var parametersDic = [String: Any]()
            parametersDic["media"] = "music"
            parametersDic["country"] = "tw"
            parametersDic["term"] = self.term
            parametersDic["offset"] = String(self.offset)
            parametersDic["limit"] = String(self.limit)
            return parametersDic
        }
        
        var method: Moya.Method { return .get }
        
        var path: String { return "/search" }
        
        var parameters: [String: Any] {
            return self.parametersDic
        }
        
        var task: Moya.Task {
            return .requestParameters(parameters: parametersDic, encoding: URLEncoding.default)
        }
        
        private var term: String
        private var offset: Int
        private var limit: Int
        
        init(pagination: Pagination) {
            self.term = pagination.term
            self.limit = pagination.limit
            self.offset = pagination.page * pagination.limit
        }
    }
}
