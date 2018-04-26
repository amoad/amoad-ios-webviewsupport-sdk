//
//  MyWebView.swift
//  AMoAdWebViewSample
//
//  Created by Takashi Kinjo on 25/04/2018.
//  Copyright © 2018 AMoAd. All rights reserved.
//

import UIKit
import WebKit
import AdSupport
import AMoAdWebViewSupport

class MyWebView: WKWebView {

    private lazy var idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    private lazy var isOptOut = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? 0 : 1

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initWebView()
    }

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.initWebView()
    }

    private lazy var support: AMoAdWebViewSupport = { fatalError("Uninitialized property access") }()

    private func initWebView() {
        self.uiDelegate = self
        self.navigationDelegate = self
        self.scrollView.bounces = false

        self.support = AMoAdWebViewSupport(webView: self)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.support.webViewDidMoveToWindow()
    }
}

extension MyWebView: WKUIDelegate, WKNavigationDelegate {
    private func handleAMoAdScheme(webView: WKWebView) {
        let script = """
        (function() {
            var message = { amoadOption: { idfa: '\(self.idfa)', optout: '\(self.isOptOut)' }};
            var target = '*';
            window.postMessage(message, target);
            for (var i = 0; i < window.frames.length; i++) {
                window.frames[i].postMessage(message, target);
            }
        })();
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.absoluteString.hasPrefix("amoadscheme://") {
            handleAMoAdScheme(webView: webView)
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // WebView 内の target='_blank' を外部ブラウザで開く
        if (navigationAction.targetFrame == nil) {
            if let url = navigationAction.request.url {
                UIApplication.shared.openURL(url)
            }
        }
        return nil
    }
}
