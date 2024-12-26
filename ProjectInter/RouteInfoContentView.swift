//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

struct RouteInfoContentView: View {
//    @EnvironmentObject var mapSelectionState: GlobalMapSelectionState
    
    @EnvironmentObject var globalDataState: GlobalDataStateObject
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
                    // TODO: implement deselection of updated map selection state
//                    mapSelectionState.selectedRoute = nil
//                    mapSelectionState.selectedShuttle = nil
                }
            }
            .padding()
            
            Section {
                VStack {
                    ForEach(viewModel.shuttles) { upcomingDeparture in
                        Divider()
                        
                        RouteInfoShuttleViewItem(shuttle: upcomingDeparture) { shuttle in
//                            mapSelectionState.selectedShuttle = shuttle
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
            if let client = globalDataState.apolloClient {
                viewModel.apolloClient = client
                viewModel.refreshData()
            } else {
                viewModel.addPlaceholderData()
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
        .environmentObject(GlobalDataStateObject())
}
