//
//  RouteListContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI
import Apollo

struct RouteListContentView: View {
    @StateObject var viewModel: RouteListContentViewModel = RouteListContentViewModel()
    
    @EnvironmentObject var globalDataState: GlobalDataState
    @EnvironmentObject var locationManagerState: LocationManagerState
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Routes")
                        .font(.title2)
                        .bold()
                    Text("Current stop: \(globalDataState.selectedStop?.name ?? "")")
                    Button("Change stop") {
                        print("Change stop pressed")
                    }
                }
                Spacer()
            }
            .padding()
            
            if locationManagerState.authorizationStatus == .notDetermined {
                GroupBox(label: Label("Enable Location Access", systemImage: "location")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("See times for your closest stop, get notifications for shuttles, and more.")
                        Button("Grant location access") {
                            locationManagerState.requestAuthorization()
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 0))
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .presentationBackground(.ultraThickMaterial)
            }
            
            ForEach(viewModel.routes) { route in
                RouteListItem(route: route) { selectedRoute in
                    globalDataState.selectedRouteId = route.id
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                
                Divider()
            }
        }
        .onAppear {
            if let apolloClient = globalDataState.apolloClient {
                viewModel.apolloClient = apolloClient
            } else {
                viewModel.addPlaceholderData()
            }
        }
        .onChange(of: globalDataState.selectedStop) {
            if let selectedStop = globalDataState.selectedStop {
                if let selectedSystem = globalDataState.selectedSystem {
                    viewModel.refreshData(systemId: selectedSystem.id, stopId: selectedStop.id)
                }
            }
        }
    }
}

struct RouteListItem: View {
    var route: RouteListContentViewRoute
    var action: (_ selectedShuttle: RouteListContentViewRoute) -> Void
    
    var body: some View {
        Button {
            action(route)
        } label: {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: route.colorHex))
                    .frame(width: 16, height: 16)
                
                VStack(alignment: .leading) {
                    Text(route.name)
                        .bold()
                    Text(route.nextStopName ?? "")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(route.etaDisplayString)
            }
            .listRowBackground(Color.clear)
            .contentShape(Rectangle())
        }
    }
}


#Preview {
    let globalDataStateObject = GlobalDataState()
    globalDataStateObject.addPlaceholderData()
    
    return RouteListContentView()
        .environmentObject(globalDataStateObject)
        .environmentObject(LocationManagerState())
}
