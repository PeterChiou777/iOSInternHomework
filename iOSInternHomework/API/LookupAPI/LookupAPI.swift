//
//  LookupAPI.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/2.
//

import Moya

enum LookupAPI {
    
    struct GetLookupResult: AppleAPITargetType, AccessTokenAuthorizable {
        var authorizationType: Moya.AuthorizationType? {
            return .bearer
        }
        
        typealias ResponseType = LookupSongResult
        
        var parametersDic: [String: Any] {
            var parametersDic = [String: Any]()
            parametersDic["id"] = String(self.id)
            parametersDic["country"] = "tw"
            return parametersDic
        }
        
        var method: Moya.Method { return .get }
        
        var path: String { return "/lookup" }
        
        var parameters: [String: Any] {
            return self.parametersDic
        }
        
        var task: Moya.Task {
            return .requestParameters(parameters: parametersDic, encoding: URLEncoding.default)
        }
        
        private var id: Int
        
        init(id: Int) {
            self.id = id
        }
    }
}
