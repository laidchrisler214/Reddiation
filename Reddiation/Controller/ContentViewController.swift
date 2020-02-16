//
//  ContentViewController.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/15/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import UIKit
import WebKit

class ContentViewController: UIViewController {
    
    var postingsModel: PostingsModel?
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = postingsModel?.title
        let url = URL(string: K.contentURL + postingsModel!.permalink)!
        webView.load(URLRequest(url: url))
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        webView.reload()
    }
}
