//
//  ChangelogWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.05.
//

import SwiftUI

struct ChangelogWebView: View {
    let url = URL(string: "https://interchange.bchen.dev/changelog")
    
    var body: some View {
        if let url = url {
            NonPersistentWebView(url: url, accessibilityIdentifier: "ChangelogWebView")
        }
    }
}

#Preview {
    ChangelogWebView()
}

