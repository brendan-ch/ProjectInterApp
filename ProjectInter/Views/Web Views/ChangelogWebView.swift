//
//  ChangelogWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.05.
//

import SwiftUI

struct ChangelogWebView: View {
    @Environment(\.dismiss) var dismiss
    
    let url = URL.changelogUrl
    
    var body: some View {
        NavigationStack {
            WebViewWithCloseButton(url: url, accessibilityIdentifier: "ChangelogWebView")
        }
    }
}

#Preview {
    ChangelogWebView()
}

