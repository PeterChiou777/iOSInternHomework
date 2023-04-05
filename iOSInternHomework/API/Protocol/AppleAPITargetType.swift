//
//  APITargetType.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/3/25.
//

import Moya

protocol DecodableResponseTargetType: TargetType {
    associatedtype ResponseType: Decodable
}

protocol AppleAPITargetType: DecodableResponseTargetType {}

extension AppleAPITargetType {
    
    var baseURL: URL { return URL(string: "https://itunes.apple.com")! }
    //https://itunes.apple.com/lookup?id=1158764002
    //https://itunes.apple.com/search?media=music&term=postmalone&limit=10&offset=0
    var headers: [String : String]? { return nil }
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}
