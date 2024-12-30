//
//  ShuttleInfoContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

/// View which displays information about a single shuttle,
/// including ETA from the currently selected stop ID.
struct ShuttleInfoContentView: View {
    /// Backing view model.
    @StateObject var viewModel = ShuttleInfoContentViewModel()
    
    /// Source of truth for the currently selected shuttle ID.
    @EnvironmentObject var globalDataState: GlobalDataState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title2)
                        .bold()
                    Text(viewModel.etaDisplay)
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
            .disabled(true)
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
        }
        .onAppear {
            if let client = globalDataState.apolloClient {
                viewModel.apolloClient = client
            } else {
                viewModel.addPlaceholderData()
            }
            
            if let systemId = globalDataState.selectedSystem?.id {
                if let stopId = globalDataState.selectedStop?.id {
                    if let shuttleId = globalDataState.selectedShuttleId {
                        viewModel.refreshData(systemId: systemId, stopId: stopId, shuttleId: shuttleId)
                    }
                }
            }
        }
        .onChange(of: globalDataState.selectedShuttleId) {
            if let systemId = globalDataState.selectedSystem?.id {
                if let stopId = globalDataState.selectedStop?.id {
                    if let shuttleId = globalDataState.selectedShuttleId {
                        viewModel.refreshData(systemId: systemId, stopId: stopId, shuttleId: shuttleId)
                    }
                }
            }
        }
    }
}

#Preview {
    return ShuttleInfoContentView()
        .environmentObject(GlobalDataState())
}
