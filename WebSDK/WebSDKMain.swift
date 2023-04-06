//
//  WebSDKMain.swift
//  WebSDK
//
//  Created by Dai Tran on 06/04/2023.
//

import WebKit
import Foundation

public final class WebSDKMain: NSObject {
    private let nativeToWebHandler = "success"
    
    private let wkWebview: WKWebView = {
        let webview = WKWebView()
        webview.configuration.preferences.javaScriptEnabled = true
        return webview
    }()
    
    private let userContentController: WKUserContentController = {
        let controller = WKUserContentController()
        return controller
    }()
    
    public override init() {
        super.init()
        wkWebview.configuration.userContentController = userContentController
        wkWebview.configuration.userContentController.add(self, name: nativeToWebHandler)
    }
    
    public func loadUrl(url: URL) {
        DispatchQueue.main.async {
            self.wkWebview.load(URLRequest(url: url))
        }
    }
    
    private func getAccountId(with trackingId: String, completion: ((String?) -> Void)?) {
        let body = [
            "trackingId": trackingId,
            "accountId": "randomString"
        ]
        
        guard
            let url = URL(string: "https://api.prod.verisoul.xyz/predict"),
            let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion?(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("8Ldtkg35pX5YoHu2N3qq89faV6fKvakh1zk7Ps5c", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
                completion?(nil)
                return
            }
            completion?(json["accountId"])
        }.resume()
    }

}

extension WebSDKMain: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        guard
            let body = message.body as? [String: String],
            let trackingId = body["trackingId"],
            message.name == nativeToWebHandler else {
            return
        }
        
        getAccountId(with: trackingId) { accountId in
            print(accountId)
        }
    }
}
