//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import Apollo

@main
struct ProjectInterApp: App {
    @StateObject var globalDataStateObject = GlobalDataModel(apolloClient:
        ApolloClient(url: URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)!)
    )
    
    @StateObject var locationManagerStateObject = GlobalLocationModel()

      var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    globalDataStateObject.refreshSystemData()
                }
                // TODO: remove once UI for selecting system is implemented
                .onChange(of: globalDataStateObject.systems) {
                    if !globalDataStateObject.systems.isEmpty && globalDataStateObject.selectedSystem == nil {
                        globalDataStateObject.selectedSystem = globalDataStateObject.systems[0]
                        if let id = globalDataStateObject.selectedSystem?.id {
                            globalDataStateObject.refreshStopData(systemId: id)
                        }
                    }
                }
                // TODO: remove once UI for selecting stop is implemented
                .onChange(of: globalDataStateObject.stops) {
                    if !globalDataStateObject.stops.isEmpty && globalDataStateObject.selectedStop == nil {
                        globalDataStateObject.selectedStop = globalDataStateObject.stops[0]
                    }
                }
        }
        .environmentObject(globalDataStateObject)
        .environmentObject(locationManagerStateObject)
    }
}

