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
    
//    @EnvironmentObject var mapSelectionState: MapSelectionState
    @EnvironmentObject var globalDataState: GlobalDataState
    
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
            
            ForEach(viewModel.routes) { route in
                RouteListItem(route: route) { selectedRoute in
                    print(route)
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                
                Divider()
            }
        }
        .onAppear {
            if let apolloClient = globalDataState.apolloClient {
                viewModel.apolloClient = apolloClient
                viewModel.getRouteData()
            } else {
                viewModel.addPlaceholderData()
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
//    let environmentObject = MapSelectionState()
    let globalDataStateObject = GlobalDataState()
    globalDataStateObject.addPlaceholderData()
    
    return RouteListContentView()
//        .environmentObject(environmentObject)
        .environmentObject(globalDataStateObject)
}
