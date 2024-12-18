//
//  RouteListContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

struct RouteListContentView: View {
    var routes: [MockRoute]
    
    @EnvironmentObject var mapSelectionState: MapSelectionState
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Routes")
                        .font(.title2)
                        .bold()
                    Text("Current stop: Chapman Court")
                    Button("Change stop") {
                        print("Change stop pressed")
                    }
                }
                Spacer()
            }
            .padding()
            
            ForEach(routes) { route in
                RouteListItem(route: route) { selectedRoute in
                    mapSelectionState.selectedRoute = selectedRoute
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                
                Divider()
            }
        }

    }
}

struct RouteListItem: View {
    var route: MockRoute
    var action: (_ selectedShuttle: MockRoute) -> Void
    
    var body: some View {
        Button {
            action(route)
        } label: {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: route.colorHex))
                    .frame(width: 16, height: 16)
                
                VStack(alignment: .leading) {
                    Text(route.label)
                        .bold()
                    Text(route.callout)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(route.timeEstimates)
            }
            .listRowBackground(Color.clear)
        }
    }
}


#Preview {
    var routes: [MockRoute] = [
        MockRoute(label: "Red Route", callout: "towards Chapman Grand", colorHex: "#db2316", timeEstimates: "5, 15 min"),
        MockRoute(label: "Teal Route", callout: "towards Panther Village", colorHex: "#21bdd1", timeEstimates: "8, 12 min")
    ]
    
    let environmentObject = MapSelectionState()
    
    RouteListContentView(routes: routes)
        .environmentObject(environmentObject)
}
