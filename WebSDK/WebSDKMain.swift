//
//  WebSDKMain.swift
//  WebSDK
//
//  Created by Dai Tran on 06/04/2023.
//

import WebKit
import Foundation

final class WebSDKMain: NSObject {
    private let nativeToWebHandler = "jsMessageHandler"
    
    private let wkWebview: WKWebView = {
        let webview = WKWebView()
        webview.configuration.preferences.javaScriptEnabled = true
        return webview
    }()
    
    private let userContentController: WKUserContentController = {
        let controller = WKUserContentController()
        return controller
    }()
    
    override init() {
        super.init()
        userContentController.add(self, name: nativeToWebHandler)
        wkWebview.configuration.userContentController = userContentController
        
        wkWebview.load(URLRequest(url: URL(string: "https://c.prod.verisoul.xyz/?projectId=test1234")!))
    }
}

extension WebSDKMain: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? String, message.name == nativeToWebHandler {
            print(body)
        }
    }
}
