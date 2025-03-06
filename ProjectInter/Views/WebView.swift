//
//  WebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let accessibilityIdentifier: String
    
    let isFile = false
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.accessibilityIdentifier = accessibilityIdentifier
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        
        if isFile {
            uiView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            uiView.load(request)
        }
    }
}
