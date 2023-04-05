//
//  WebViewURLViewController.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/3.
//

import UIKit
import Reusable
import WebKit

class WebViewURLViewController: UIViewController, StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard.Main
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCloseButton()
        loadWebView()
    }
    
    func setupCloseButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc func closeTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadWebView() {
        guard let urlString = url else {
            ErrorHelper.track()
            return }
        guard let url = URL(string: urlString) else {
            ErrorHelper.track()
            return }
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
        }
        //呼叫後會有紫色警告
        //This method should not be called on the main thread as it may lead to UI unresponsiveness.
        //目前判斷是Apple的bug，也在Stackoverflow和Apple Developer上看到蠻多開發者遇到一樣的問題而且也都是近期發生的
        //資料來源：
        //https://developer.apple.com/forums/thread/713290
        //https://stackoverflow.com/questions/74038451/in-xcode-14-ios-16-purple-warnings-starting-with-this-method-should-not-be-ca
        //https://developer.apple.com/forums/thread/714467?answerId=734799022#734799022
    }
    
}
