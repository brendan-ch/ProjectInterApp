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
    
    @StateObject var globalNotificationsStateObject = GlobalNotificationsModel()
    
    var canAutomaticallySelectStop: Bool {
        globalStopsStateObject.selectedStop == nil
        && locationManagerStateObject.lastUpdatedLocation != nil
        && globalStopsStateObject.stops.count > 0
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await globalDataStateObject.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
                    locationManagerStateObject.updateLocationOnce()
                }
                .task {
                    // TODO: Change this into a button press, this may violate HIG
                    await globalNotificationsStateObject.requestAuthorization()
                    let status = await globalNotificationsStateObject.getAuthorizationStatus()
                    
                    switch status {
                    case .authorized:
                        print("Authorized")
                    case .denied:
                        print("Denied")
                    case .notDetermined:
                        print("Not requested yet")
                    case .provisional:
                        print("Provisional")
                    case .ephemeral:
                        print("Ephemeral")
                    @unknown default:
                        fatalError()
                    }
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
        }
        .environmentObject(globalDataStateObject)
        .environmentObject(globalStopsStateObject)
        .environmentObject(locationManagerStateObject)
    }
}

class ApolloClientHolderSingleton {
    static let shared = ApolloClientHolderSingleton()
    
    let apolloClient: ApolloClientProtocol
    
    private init() {
        apolloClient = ApolloClient(url: URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)!)
    }
}

