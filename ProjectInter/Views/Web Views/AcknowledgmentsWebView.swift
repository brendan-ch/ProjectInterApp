//
//  AcknowledgmentsWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import SwiftUI

struct AcknowledgmentsWebView: View {
    let url = URL(string: "https://interchange.bchen.dev/acknowledgements")
    
    var body: some View {
        NavigationStack {
            if let url = url {
                WebViewWithCloseButton(url: url, accessibilityIdentifier: "AcknowledgmentsWebView")
            }
        }
    }
}

#Preview {
    AcknowledgmentsWebView()
}
