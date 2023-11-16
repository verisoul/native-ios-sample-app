//
//  ViewController.swift
//  Sample
//

import UIKit
import ZeroFakeDemo

class ViewController: UIViewController {
    private let env = "sandbox" // or "prod"
    private let projectId = "<YOUR SANDBOX PROJECT ID>" // or prod projectId
    private let apiKey = "<YOUR API KEY>"
    private var demo: Demo!
    
    var webViewUrl : String {
        return "https://js.verisoul.ai/\(env)/webview.html?project_id=\(projectId)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo = Demo(env: env, apiKey: apiKey)
        
        self.demo.loadUrl(url: URL(string: webViewUrl)!, from: self)
    }
}

