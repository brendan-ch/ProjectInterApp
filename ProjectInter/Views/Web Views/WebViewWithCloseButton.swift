//
//  WebViewWithCloseButton.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import SwiftUI

struct WebViewWithCloseButton: View {
    @Environment(\.dismiss) var dismiss
    
    let url: URL
    let accessibilityIdentifier: String
    
    var body: some View {
        NonPersistentWebView(url: url, accessibilityIdentifier: accessibilityIdentifier)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
    }
}
