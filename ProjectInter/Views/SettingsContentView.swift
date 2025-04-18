//
//  SettingsView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct SettingsContentView: View {
    var body: some View {
        RootSheetContentView(title: "Settings") {
            VStack(spacing: 0) {
                GroupBox(label: Text("Version")) {
                    VStack(alignment: .leading) {
                        Text("App version: 1.0.0")
                        
                        Button {
                            
                        } label: {
                            Text("View changelog")
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                }
                .padding()
                
                GroupBox(label: Text("Feedback")) {
                    VStack(alignment: .leading) {
                        Text("Help me make this app better!")
                        
                        Button {
                            
                        } label: {
                            Text("Send feedback")
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                }
                .padding()
            }
        }
    }
}

#Preview {
    SettingsContentView()
}
