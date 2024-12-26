//
//  ShuttleInfoContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

struct ShuttleInfoContentView: View {
    @StateObject var viewModel = ShuttleInfoContentViewModel()
    @EnvironmentObject var globalDataState: GlobalDataState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title2)
                        .bold()
                    Text("Jacaranda St.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text(viewModel.etaDisplay)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("Last updated now")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    globalDataState.selectedShuttleId = nil
                }
            }
            .padding()
            
            Button(action: {}) {
                HStack {
                    Spacer()
                    Image(systemName: "bell.badge")
                    Text("Notify me when nearby")
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
        }
        .onAppear {
            if let client = globalDataState.apolloClient {
                if let shuttleId = globalDataState.selectedShuttleId {
                    viewModel.apolloClient = client
                    viewModel.refreshData(shuttleId: shuttleId)
                    
                    return
                }
            }
            
            viewModel.addPlaceholderData()
        }
    }
}

#Preview {
    return ShuttleInfoContentView()
        .environmentObject(GlobalDataState())
}
