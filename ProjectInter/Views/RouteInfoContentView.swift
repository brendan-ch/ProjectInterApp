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
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    @Environment(GlobalStopsModel.self) var globalStopsState: GlobalStopsModel
    
    /// Backing ``RouteInfoContentView`` instance.
    @State var viewModel: ViewModel = ViewModel()
    
    var networkArguments: RouteInfoNetworkArguments? {
        guard let systemId = globalSystemsModel.selectedSystem?.id,
              let stopId = globalStopsState.selectedStop?.id,
              let routeId = globalIdSelectionModel.selectedRouteId else { return nil }
        
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
                
                if globalIdSelectionModel.selectedShuttleId == nil {
                    Button("Close") {
                        globalIdSelectionModel.selectedRouteId = nil
                        globalIdSelectionModel.selectedShuttleId = nil
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
            
            WithInitializationView(dataInitState: viewModel.dataInitState) {
                DataWrapperView(
                    shouldDisplayNoDataMessage: viewModel.shuttles.isEmpty,
                    noDataMessage: "No shuttles available"
                ) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(viewModel.shuttles) { upcomingDeparture in
                                Divider()
                                
                                RouteInfoShuttleViewItem(shuttle: upcomingDeparture) { shuttle in
                                    globalIdSelectionModel.selectedShuttleId = shuttle.id
                                }
                                .accessibilityLabel("Shuttle label in route info page")
                                .accessibilityIdentifier(upcomingDeparture.id)
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                                
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .onAppear {
            restartDataUpdates()
        }
        .onChange(of: globalIdSelectionModel.selectedRouteId) {
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
    let model = RouteInfoContentView.ViewModel.buildPlaceholder()
    
    return RouteInfoContentView(viewModel: model)
        .environment(GlobalIdSelectionModel())
        .environment(GlobalStopsModel())
        .environment(GlobalSystemsModel.buildPlaceholder())
}
