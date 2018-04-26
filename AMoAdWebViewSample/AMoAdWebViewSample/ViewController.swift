//
//  ViewController.swift
//  AMoAdWebViewSample
//
//  Created by Takashi Kinjo on 25/04/2018.
//  Copyright © 2018 AMoAd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ad", ofType: "html")!)

    private lazy var webView: MyWebView = { fatalError("Uninitialized property access") }()
    @IBOutlet weak var webViewContainer: UIView!

    override func viewDidLoad() {
        self.webView = MyWebView()
        layoutWebView()

        self.webView.load(URLRequest(url: url))
    }

    private func layoutWebView() {
        self.webViewContainer.addSubview(self.webView)

        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", metrics: nil, views: ["webView": self.webView]))
        self.webViewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", metrics: nil, views: ["webView": self.webView]))
    }
}
