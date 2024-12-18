//
//  RouteListContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

struct RouteListContentView: View {
    var routes: [MockRoute]
    
    @Binding var isPresented: Bool
    @Binding var isShowingNestedSheet: Bool
    
    @State private var selectedRoute: MockRoute?
    
    @Binding var selectedShuttle: Shuttle?
    @Binding var showingShuttleInfoSheet: Bool
    
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
                    isShowingNestedSheet = true
                    self.selectedRoute = selectedRoute
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                
                Divider()
            }
        }
        .sheet(isPresented: $isShowingNestedSheet) {
            if let selectedRoute {
                RouteInfoContentView(isShowing: $isShowingNestedSheet, routeToDisplay: selectedRoute)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .presentationDetents([.height(210), .height(360), .large])
                    .presentationBackground(.regularMaterial)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingShuttleInfoSheet) {
            if let selectedShuttle {
                ShuttleInfoContentView(isShowing: $showingShuttleInfoSheet, shuttle: selectedShuttle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .presentationDetents([.height(210), .height(360), .large])
                    .presentationBackground(.regularMaterial)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
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
    
    RouteListContentView(routes: routes, isPresented: .constant(true), isShowingNestedSheet: .constant(false), selectedShuttle: .constant(nil), showingShuttleInfoSheet: .constant(false))
}
