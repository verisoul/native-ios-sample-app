//
//  ViewController.swift
//  Sample
//
//  Created by Hyel on 06/04/2023.
//

import UIKit
import ZeroFakeDemo

class ViewController: UIViewController {
    private let env = "sandbox" // or "prod"
    private let projectId = "yourSandboxVerisoulProjectID" // or prod projectId
    private let demo = ZeroFakeDemo()
    
    var webViewUrl : String {
        return "https://webview.\(env).verisoul.xyz/?projectId=\(projectId)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo.loadUrl(url: URL(string: webViewUrl)!, from: self)
    }
}

