//
//  FeedbackWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct FeedbackWebView: View {
    @Environment(\.dismiss) var dismiss
    let url = URL(string: "https://bchendev.notion.site/1ba07b1035c680b48de1e4acf3b2ff37?pvs=105")
    
    var body: some View {
        NavigationStack {
            if let url = url {
                NonPersistentWebView(url: url, accessibilityIdentifier: "FeedbackWebView")
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
    }
}

#Preview {
    FeedbackWebView()
}


