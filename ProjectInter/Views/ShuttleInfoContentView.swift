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
    @EnvironmentObject var globalDataState: GlobalDataModel
    
    @EnvironmentObject var globalStopsState: GlobalStopsModel
    
    var shuttleInfoNetworkArguments: ShuttleInfoNetworkArguments? {
        guard let systemId = globalDataState.selectedSystem?.id,
              let shuttleId = globalDataState.selectedShuttleId,
              let stopId = globalStopsState.selectedStop?.id
            else { return nil }
        
        return ShuttleInfoNetworkArguments(
            systemId: systemId,
            stopId: stopId,
            shuttleId: shuttleId
        )
    }
    
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
            }
            if let arguments = shuttleInfoNetworkArguments {
                Task {
                    await viewModel.refreshDataOnce(arguments: arguments)
                }
            }
        }
        .onChange(of: globalDataState.selectedShuttleId) {
            if let arguments = shuttleInfoNetworkArguments {
                Task {
                    await viewModel.refreshDataOnce(arguments: arguments)
                }
            }
        }
    }
}

#Preview {
    let builder = ShuttleInfoContentViewModelPlaceholderBuilder()
    let model = builder.build()
    
    return ShuttleInfoContentView(viewModel: model)
        .environmentObject(GlobalDataModel())
        .environmentObject(GlobalStopsModel())
}
