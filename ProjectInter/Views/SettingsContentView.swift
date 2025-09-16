//
//  SettingsView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct SettingsContentView: View {
    @State private var showChangelogView = false
    
    @State var changelogVersionModel = AppVersionModel()
    
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    @State private var showFeedbackView = false
    
    @State private var showSystemPickerView = false
    
    @State private var showAcknowledgmentsView = false
    
    var body: some View {
        HeadingWrapperView(title: "Settings") {
            VStack(spacing: 0) {
                GroupBox {
                    Button {
                        showSystemPickerView = true
                    } label: {
                        HStack {
                            Text("System")
                            Spacer()
                            
                            if let name = globalSystemsModel.selectedSystem?.name {
                                Text(name)
                                    .lineLimit(1)
                            } else {
                                Text("N/A")
                            }
                            
                            Image(systemName: "chevron.right")
                                .tint(.secondary)
                        }
                    }
                    .tint(Color.primary)
                }
                .padding()
                
                GroupBox(label: Text("Version")) {
                    VStack(alignment: .leading) {
                        if let marketingVersion = changelogVersionModel.getCurrentAppMarketingVersion() {
                            Text("App version: \(marketingVersion)")
                        } else {
                            Text("App version: N/A")
                        }
                        
                        Button {
                            showChangelogView = true
                            changelogVersionModel.updateLastViewedChangelogVersion()
                        } label: {
                            Text("See what's new")
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
                        
                        Link(destination: .feedbackUrl){
                            Text("Open issue tracker")
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                }
                .padding()
                
                Button {
                    showAcknowledgmentsView = true
                } label: {
                    Text("View acknowledgments")
                        .font(.footnote)
                }
            }
        }
        .sheet(isPresented: $showChangelogView) {
            ChangelogWebView()
        }
        .sheet(isPresented: $showSystemPickerView) {
            SystemSelectionView()
        }
        .sheet(isPresented: $showAcknowledgmentsView) {
            AcknowledgementsWebView()
        }
    }
}

#Preview {
    SettingsContentView()
        .environment(GlobalSystemsModel())
}
