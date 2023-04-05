//
//  ErrorHelper.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/4.
//

import UIKit
import Moya

class ErrorHelper {
    //快速找到發生錯誤的地方
   static func track(file: String = #file, function: String = #function, line: Int = #line) {
        print("[Error] \n file: \((file as NSString).lastPathComponent) \n function: \(function) \n line: \(line)")
    }
    
    static func trackWithText(messsage: String, file: String = #file, function: String = #function, line: Int = #line){
        print("[Error] \n \(messsage) \n file: \((file as NSString).lastPathComponent) \n function: \(function) \n line: \(line)")
    }
    
    static func handleMoyaError(error: Swift.Error) {
        if let error = error as? MoyaError,
           let errorMessage = try? error.response?.mapJSON() {
            print("[Error]：\(error.errorDescription ?? "")")
            print("[Error Info]：\(error.errorUserInfo)")
            print(errorMessage)
        }
    }
}
