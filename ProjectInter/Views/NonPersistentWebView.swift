//
//  WebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import SwiftUI
import WebKit

struct NonPersistentWebView: UIViewRepresentable {
    let url: URL
    let accessibilityIdentifier: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.accessibilityIdentifier = accessibilityIdentifier
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
