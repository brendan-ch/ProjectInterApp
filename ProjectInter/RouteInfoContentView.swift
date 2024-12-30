//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

/// View which displays information for the currently selected
/// route in ``GlobalDataState`` and a list of upcoming shuttles.
struct RouteInfoContentView: View {
    /// ``GlobalDataState`` instance containing the currently selected route
    /// and `ApolloClient` instance.
    @EnvironmentObject var globalDataState: GlobalDataState
    
    /// Backing ``RouteInfoContentView`` instance.
    @StateObject var viewModel: RouteInfoContentViewModel = RouteInfoContentViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.routeName)
                        .font(.title2)
                        .bold()
                    Text(viewModel.routeNextStopName ?? "")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    globalDataState.selectedRouteId = nil
                    globalDataState.selectedShuttleId = nil
                }
            }
            .padding()
            
            Section {
                VStack {
                    ForEach(viewModel.shuttles) { upcomingDeparture in
                        Divider()
                        
                        RouteInfoShuttleViewItem(shuttle: upcomingDeparture) { shuttle in
                            globalDataState.selectedShuttleId = shuttle.id
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        
                    }
                }
            } header: {
                HStack {
                    Text("Upcoming departures")
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            // Control which dataset to use depending on Apollo client
            if let client = globalDataState.apolloClient {
                viewModel.apolloClient = client
            } else {
                viewModel.addPlaceholderData()
            }
            
            if let systemId = globalDataState.selectedSystem?.id {
                if let stopId = globalDataState.selectedStop?.id {
                    if let routeId = globalDataState.selectedRouteId {
                        viewModel.refreshData(systemId: systemId, stopId: stopId, routeId: routeId)
                    }
                }
            }
        }
        .onChange(of: globalDataState.selectedRouteId) {
            if let systemId = globalDataState.selectedSystem?.id {
                if let stopId = globalDataState.selectedStop?.id {
                    if let routeId = globalDataState.selectedRouteId {
                        viewModel.refreshData(systemId: systemId, stopId: stopId, routeId: routeId)
                    }
                }
            }
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
    return RouteInfoContentView()
        .environmentObject(GlobalDataState())
}
