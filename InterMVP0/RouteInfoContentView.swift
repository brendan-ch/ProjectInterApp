//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

struct RouteInfoContentView: View {
    @EnvironmentObject var mapSelectionState: MapSelectionState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(mapSelectionState.selectedRoute?.label ?? "")
                        .font(.title2)
                        .bold()
                    Text(mapSelectionState.selectedRoute?.callout ?? "")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    mapSelectionState.selectedRoute = nil
                    mapSelectionState.selectedShuttle = nil
                }
            }
            .padding()
            
            Section {
                VStack {
                    ForEach(mapSelectionState.selectedRoute?.shuttles ?? []) { upcomingDeparture in
                        Divider()
                        
                        ShuttleListItem(shuttle: upcomingDeparture) { shuttle in
                            mapSelectionState.selectedShuttle = shuttle
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
    }
}

#Preview {
    let route = MockRoute(label: "Red Route", callout: "towards Chapman Grand", colorHex: "#db2316", timeEstimates: "5, 15 min")

    let upcomingDepartures = [
        Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away"),
        Shuttle(currentLatitude: 33.78788, currentLongitude: -117.85921, label: "Red Shuttle 25", estimatedTimeAwayDisplay: "15 min away")
    ]
    
    route.shuttles = upcomingDepartures
    
    let environmentObject = MapSelectionState()
    environmentObject.selectedRoute = route
    
    return RouteInfoContentView()
        .environmentObject(environmentObject)
}
