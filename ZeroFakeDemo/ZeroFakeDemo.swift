//
//  WebSDKMain.swift
//  WebSDK
//
//  Created by Dai Tran on 06/04/2023.
//

import WebKit
import Foundation

public final class ZeroFakeDemo: NSObject {
    private let nativeToWebHandler = "error"
    private let apiKey = "yourVerisoulApiKey"
    
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
    
    public func loadUrl(url: URL, from viewController: UIViewController) {
        DispatchQueue.main.async {
            viewController.view.addSubview(self.wkWebview)
            self.wkWebview.frame = .zero
            
            self.wkWebview.load(URLRequest(url: url))
        }
    }
    
    // Make this API call from a secure backend server NOT the client app
    // Note: this is included in the sample app for demo purposes
    private func getAccountId(with trackingId: String, completion: ((String?) -> Void)?) {
        let body = [
            "tracking_id": trackingId,
            "account_id": "internal-customer-identifier"
        ]
        
        guard
            let url = URL(string: "https://api.sandbox.verisoul.xyz/predict"),
            let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion?(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion?(nil)
                return
            }
            let accountId = json["account_id"] as? String
            completion?(accountId)
        }.resume()
    }

}

extension ZeroFakeDemo: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        print(message.body)
        guard
            let body = message.body as? [String: String],
            let trackingId = body["tracking_id"],
            message.name == nativeToWebHandler else {
            return
        }
        
        getAccountId(with: trackingId) { accountId in
            print(accountId as Any)
        }
    }
}
