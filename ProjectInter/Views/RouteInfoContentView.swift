//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

/// View which displays information for the currently selected
/// route in ``GlobalDataState`` and a list of upcoming shuttles.
struct RouteInfoContentView: NetworkView {
    /// ``GlobalDataState`` instance containing the currently selected route
    /// and `ApolloClient` instance.
    @EnvironmentObject var globalDataModel: GlobalDataModel
    
    @EnvironmentObject var globalStopsState: GlobalStopsModel
    
    /// Backing ``RouteInfoContentView`` instance.
    @StateObject var viewModel: RouteInfoContentViewModel = RouteInfoContentViewModel()
    
    var networkArguments: RouteInfoNetworkArguments? {
        guard let systemId = globalDataModel.selectedSystem?.id,
              let stopId = globalStopsState.selectedStop?.id,
              let routeId = globalDataModel.selectedRouteId else { return nil }
        
        
        return RouteInfoNetworkArguments(systemId: systemId, stopId: stopId, routeId: routeId)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.routeName)
                        .font(.title2)
                        .bold()
                    Text("Towards \(viewModel.routeNextStopName ?? "unknown stop")")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                if globalDataModel.selectedShuttleId == nil {
                    Button("Close") {
                        globalDataModel.selectedRouteId = nil
                        globalDataModel.selectedShuttleId = nil
                    }
                }
            }
            .padding()
            
            HStack {
                Text("Upcoming departures")
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                Section {
                    VStack {
                        ForEach(viewModel.shuttles) { upcomingDeparture in
                            Divider()
                            
                            RouteInfoShuttleViewItem(shuttle: upcomingDeparture) { shuttle in
                                globalDataModel.selectedShuttleId = shuttle.id
                            }
                            .accessibilityLabel("Shuttle label in route info page")
                            .accessibilityIdentifier(upcomingDeparture.id)
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                        }
                    }
                }
            }
        }
        .onAppear {
            restartDataUpdates()
        }
        .onChange(of: globalDataModel.selectedRouteId) {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
    }
}

struct RouteInfoShuttleViewItem: View {
    var shuttle: RouteInfoContentViewShuttle
    var action: (_ selectedShuttle: RouteInfoContentViewShuttle) -> Void
    
    var body: some View {
        Button {
            action(shuttle)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(shuttle.name)
                        .bold()
                    Text(shuttle.estimatedTimeAwayDisplay)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    let builder = RouteInfoContentViewModelPlaceholderBuilder()
    let model = builder.build()
    
    return RouteInfoContentView(viewModel: model)
        .environmentObject(GlobalDataModel())
        .environmentObject(GlobalStopsModel())
}
