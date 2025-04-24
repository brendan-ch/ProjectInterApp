//
//  AppUpdateMessageView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.23.
//

import SwiftUI

struct AppUpdateMessageView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Update your app version")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("To continue using Interchange, please update to the latest version of the app.")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    AppUpdateMessageView()
}

