//
//  API.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/3/25.
//

import UIKit
import Moya
import RxSwift

final public class API {
    public static let shared = API()
    private init() {}
    
    private var provider:
    MoyaProvider<MultiTarget> = {
        return MoyaProvider<MultiTarget>()
    }()
    
    public func update(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    //自動轉化物件
    func request<Request: DecodableResponseTargetType>(_ request: Request) -> PrimitiveSequence<SingleTrait, Response> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
    }
    
    //手動轉化物件
    func requestAutoMap<Request: DecodableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self, atKeyPath: nil)
    }
}
