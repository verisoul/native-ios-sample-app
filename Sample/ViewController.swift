//
//  ViewController.swift
//  Sample
//
//  Created by Hyel on 06/04/2023.
//

import UIKit
import WebSDK

class ViewController: UIViewController {
    private let webSdk = WebSDKMain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webSdk.loadUrl(url: URL(string: "https://webview.dev.verisoul.xyz/?projectId=1234")!)
    }
}

