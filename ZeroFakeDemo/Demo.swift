//
//  WebSDKMain.swift
//  WebSDK
//

import WebKit
import Foundation

typealias JSON = [String: Any]

public final class Demo: NSObject {
    private let env: String
    private let apiKey: String
    private let nativeToWebHandler = "verisoulHandler"
    private let wkWebview: WKWebView = {
        let webview = WKWebView()
        webview.configuration.preferences.javaScriptEnabled = true
        return webview
    }()
    
    private let userContentController: WKUserContentController = {
        let controller = WKUserContentController()
        return controller
    }()
    
    public init(env: String, apiKey: String) {
        self.env = env
        self.apiKey = apiKey
        super.init()
        wkWebview.configuration.userContentController = userContentController
        wkWebview.configuration.userContentController.add(self, name: nativeToWebHandler)
    }
    
    public func loadUrl(url: URL, from viewController: UIViewController) {
        print("Loading webview...")
        DispatchQueue.main.async {
            viewController.view.addSubview(self.wkWebview)
            self.wkWebview.frame = .zero
            
            self.wkWebview.load(URLRequest(url: url))
        }
    }
    
    // Make this API call from a secure backend server NOT the client app
    // Note: this is included in the sample app for demo purposes
    private func predict(with sessionId: String, completion: ((JSON?) -> Void)?) {
        let body: [String: Any] = [
            "session_id": sessionId,
            "account": [
                "id": "internal-customer-identifier"
            ]
        ]

        guard
            let url = URL(string: "https://api.\(env).verisoul.ai/session/authenticate"),
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
            completion?(json)
        }.resume()
    }
}

extension Demo: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        guard
            let body = message.body as? [String: String],
            message.name.lowercased() == nativeToWebHandler.lowercased(),
            let sessionId = body["session_id"]
        else {
            return
        }
        
        predict(with: sessionId) { response in
            print("Verisoul API Response: ")
            print(response as Any)
        }
    }
}
