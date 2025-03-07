//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import WebKit
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
        globalStopsStateObject.isAutomaticWhenLocationIsAvailable
        && globalStopsStateObject.stops.count > 0
    }
    
    var body: some Scene {
        WindowGroup {
            let setupCompleted = setupStateModel.setupCompleted
            if setupCompleted {
                ContentView()
                    .task {
                        // Perform overall global data refresh
                        await globalDataStateObject.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
                    }
                    .onChange(of: globalDataStateObject.selectedSystem) {
                        // Grab the available stops for the system
                        guard let systemId = globalDataStateObject.selectedSystem?.id else { return }
                        
                        Task {
                            let stopsNetworkArguments = GlobalStopsNetworkArguments(
                                systemId: systemId
                            )
                            await globalStopsStateObject.refreshDataOnce(arguments: stopsNetworkArguments)
                        }
                    }
                    .task {
                        updateGlobalStopsStateAutomaticState()
                    }
                    .onChange(of: locationManagerStateObject.lastUpdatedLocation) {
                        guard let location = locationManagerStateObject.lastUpdatedLocation else { return }
                        
                        if canAutomaticallySelectStop {
                            globalStopsStateObject.selectClosestStopBasedOnLocation(location: location)
                        }
                    }
            } else {
                WelcomeContentView()
                    .environmentObject(setupStateModel)
                    .environmentObject(customAppDelegate)
            }
        }
        .environmentObject(globalDataStateObject)
        .environmentObject(globalStopsStateObject)
        .environmentObject(locationManagerStateObject)
        .environmentObject(globalNotificationsStateObject)
    }
    
    func updateGlobalStopsStateAutomaticState() {
        if locationManagerStateObject.authorizationStatusInitialized {
            if locationManagerStateObject.authorizationStatus == .authorizedAlways || locationManagerStateObject.authorizationStatus == .authorizedWhenInUse {
                globalStopsStateObject.isAutomaticWhenLocationIsAvailable = true
            }
        }
    }
}

class ApolloClientHolderSingleton {
    static let shared = ApolloClientHolderSingleton()
    
    let apolloClient: ApolloClientProtocol
    
    private init() {
        apolloClient = ApolloClient(url: URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)!)
    }
}

