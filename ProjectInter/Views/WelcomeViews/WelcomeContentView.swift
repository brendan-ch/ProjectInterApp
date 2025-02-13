//
//  WelcomeContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.13.
//

import SwiftUI

struct WelcomeContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeView(onContinue: {})
        }
    }
}

#Preview {
    WelcomeContentView()
}
