//
//  ViewController.swift
//  Sample
//

import UIKit
import Demo

class ViewController: UIViewController {
    private let env = "sandbox" // or "prod"
//    private let projectId = "<YOUR SANDBOX PROJECT ID>" // or prod projectId
//    private let apiKey = "<YOUR API KEY>"
    private let projectId = "00000000-0000-0000-0000-000000000001"
    private let apiKey = "KxEv9FlAmC6h6L8uJxctYaAt4IjWoebAarqthqV5"
    private var demo: Demo!
    
    var webViewUrl : String {
        return "https://js.verisoul.ai/\(self.env)/webview.html?project_id=\(self.projectId)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo = Demo(env: env, apiKey: apiKey)
        
        self.demo.loadUrl(url: URL(string: webViewUrl)!, from: self)
    }
}

