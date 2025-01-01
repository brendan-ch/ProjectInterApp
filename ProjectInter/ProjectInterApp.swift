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
    
    @StateObject var locationManagerStateObject = GlobalLocationDataModel()

      var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    globalDataStateObject.refreshData(arguments: GlobalDataModelNetworkArguments())
                }
        }
        .environmentObject(globalDataStateObject)
        .environmentObject(locationManagerStateObject)
    }
}

