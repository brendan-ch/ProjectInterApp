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
    @StateObject var locationManagerStateObject = GlobalLocationDataModel()
    
    @StateObject var globalDataStateObject = GlobalDataModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @StateObject var globalStopsStateObject = GlobalStopsModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @StateObject var globalNotificationsStateObject = GlobalNotificationSchedulingModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @StateObject var setupStateModel = SetupStateModel()
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var customAppDelegate: CustomAppDelegate
    
    var canAutomaticallySelectStop: Bool {
        globalStopsStateObject.selectedStop == nil
        && locationManagerStateObject.lastUpdatedLocation != nil
        && globalStopsStateObject.stops.count > 0
    }
    
    var body: some Scene {
        WindowGroup {
            let setupCompleted = setupStateModel.setupCompleted
            if setupCompleted {
                ContentView()
                    .task {
                        await globalDataStateObject.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
                        locationManagerStateObject.updateLocationOnce()
                    }
                    .onChange(of: globalDataStateObject.selectedSystem) {
                        guard let systemId = globalDataStateObject.selectedSystem?.id else { return }
                        
                        Task {
                            let stopsNetworkArguments = GlobalStopsNetworkArguments(
                                systemId: systemId
                            )
                            await globalStopsStateObject.refreshDataOnce(arguments: stopsNetworkArguments)
                        }
                    }
                    .onChange(of: canAutomaticallySelectStop) {
                        guard let location = locationManagerStateObject.lastUpdatedLocation else { return }
                        
                        if canAutomaticallySelectStop {
                            globalStopsStateObject.selectClosestStopBasedOnLocation(location: location)
                        }
                    }
            } else {
                WelcomeContentView()
                    .environmentObject(setupStateModel)
            }
        }
        .environmentObject(globalDataStateObject)
        .environmentObject(globalStopsStateObject)
        .environmentObject(locationManagerStateObject)
        .environmentObject(globalNotificationsStateObject)
    }
}

class ApolloClientHolderSingleton {
    static let shared = ApolloClientHolderSingleton()
    
    let apolloClient: ApolloClientProtocol
    
    private init() {
        apolloClient = ApolloClient(url: URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)!)
    }
}

