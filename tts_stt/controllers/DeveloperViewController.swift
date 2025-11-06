//
//  DeveloperViewController.swift
//  mood_capture
//
//  Created by MacBook on 07/01/25.
//

import UIKit
import WebKit

class DeveloperViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://bhushankoli.in") {
               let request = URLRequest(url: url)
               webView.load(request)
           }
    }

}
