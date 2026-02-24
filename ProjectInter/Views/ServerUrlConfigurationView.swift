//
//  ServerUrlConfigurationView.swift
//  ProjectInter
//
//  Created by Claude on 2026.02.23.
//

import SwiftUI

struct ServerUrlConfigurationView: View {
    @Environment(ServerUrlConfigurationModel.self) var serverUrlConfigModel: ServerUrlConfigurationModel
    @Environment(\.dismiss) var dismiss

    @State private var urlText: String = ""
    @State private var showInvalidUrlAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Server URL", text: $urlText)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text("Custom server URL")
                } footer: {
                    Text("Leave empty to use the default server.")
                }

                if !urlText.isEmpty {
                    Section {
                        Button("Reset to default", role: .destructive) {
                            urlText = ""
                        }
                    }
                }
            }
            .navigationTitle("Server configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if serverUrlConfigModel.applyServerUrl(urlText) {
                            dismiss()
                        } else {
                            showInvalidUrlAlert = true
                        }
                    }
                }
            }
            .alert("Invalid URL", isPresented: $showInvalidUrlAlert) {
                Button("OK") {}
            } message: {
                Text("Please enter a valid URL (starting with http:// or https://) or leave the field empty to use the default server.")
            }
            .onAppear {
                urlText = serverUrlConfigModel.customServerUrlString ?? ""
            }
        }
    }
}

#Preview {
    ServerUrlConfigurationView()
        .environment(ServerUrlConfigurationModel())
}
