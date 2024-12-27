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
