//
//  ChangelogWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.05.
//

import SwiftUI

struct ChangelogWebView: View {
    @Environment(\.dismiss) var dismiss
    
    let url = URL(string: "https://interchange.bchen.dev/changelog")
    
    var body: some View {
        NavigationStack {
            if let url = url {
                NonPersistentWebView(url: url, accessibilityIdentifier: "ChangelogWebView")
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
    ChangelogWebView()
}

