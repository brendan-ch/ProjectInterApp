//
//  FeedbackWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct FeedbackWebView: View {
    let url = URL(string: "https://bchendev.notion.site/1ba07b1035c680b48de1e4acf3b2ff37?pvs=105")
    
    var body: some View {
        if let url = url {
            NonPersistentWebView(url: url, accessibilityIdentifier: "ChangelogWebView")
        }
    }
}

#Preview {
    FeedbackWebView()
}


