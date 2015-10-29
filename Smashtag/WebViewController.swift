//
//  WebViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    // MARK: - Public API
    
    var urlPath: String? {
        didSet {
            loadAddressUrl()
        }
    }
    
    // MARK: - Outlet
    
    @IBOutlet private weak var webView: UIWebView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.scalesPageToFit = true
        loadAddressUrl()
    }
    
    // MARK: - Core Function
    
    private func loadAddressUrl() {
        if let url = urlPath {
            if let requestUrl = NSURL(string: url) {
                webView?.loadRequest(NSURLRequest(URL: requestUrl))
            }
        }
    }
    
}
