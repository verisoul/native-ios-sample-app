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
        webSdk.loadUrl(url: URL(string: "https://c.prod.verisoul.xyz/?projectId=test1234")!)
    }
}

