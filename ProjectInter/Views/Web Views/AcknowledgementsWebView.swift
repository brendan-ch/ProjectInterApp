//
//  AcknowledgmentsWebView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import SwiftUI

struct AcknowledgementsWebView: View {
    let url = URL.acknowledgementsUrl
    
    var body: some View {
        NavigationStack {
            WebViewWithCloseButton(url: url, accessibilityIdentifier: "AcknowledgmentsWebView")
        }
    }
}

#Preview {
    AcknowledgementsWebView()
}
