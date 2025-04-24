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
import Combine

@main
struct ProjectInterApp: App {
    @StateObject var locationManagerStateObject = GlobalLocationDataModel()
    
    @StateObject var globalIdSelectionStateObject = GlobalIdSelectionModel()
    
    @StateObject var globalSystemsStateObject = GlobalSystemsModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @StateObject var globalStopsStateObject = GlobalStopsModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @StateObject var globalNotificationsStateObject = GlobalNotificationSchedulingModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @StateObject var setupStateModel = SetupStateModel()
    
    @StateObject var schemaVersionModel = SchemaVersionModel(
        apolloClient: ApolloClientHolderSingleton.shared.apolloClient,
        appSchemaVersion: Bundle.main.infoDictionary?["APP_SCHEMA_VERSION"] as? Int
    )
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var customAppDelegate: CustomAppDelegate
    
    var body: some Scene {
        WindowGroup {
            let setupCompleted = setupStateModel.setupCompleted
            if !schemaVersionModel.isCompatible {
                AppUpdateMessageView()
                    .task {
                        schemaVersionModel.startRefreshingData(arguments: SchemaVersionModelNetworkArguments(), sleepDuration: .seconds(60))
                    }
            } else if setupCompleted {
                ContentViewWrapper()
            } else {
                WelcomeContentView()
                    .environmentObject(setupStateModel)
                    .environmentObject(customAppDelegate)
            }
        }
        .environmentObject(globalIdSelectionStateObject)
        .environmentObject(globalSystemsStateObject)
        .environmentObject(globalStopsStateObject)
        .environmentObject(locationManagerStateObject)
        .environmentObject(globalNotificationsStateObject)
        .environmentObject(customAppDelegate.notificationCenterDelegate)
    }
    
}

struct ContentViewWrapper: View {
    @EnvironmentObject var globalSystemsStateObject: GlobalSystemsModel
    @EnvironmentObject var globalIdSelectionStateObject: GlobalIdSelectionModel
    @EnvironmentObject var globalStopsStateObject: GlobalStopsModel
    @EnvironmentObject var locationManagerStateObject: GlobalLocationDataModel
    @EnvironmentObject var customAppDelegate: CustomAppDelegate
    @EnvironmentObject var notificationCenterDelegate: CustomNotificationCenterDelegate
    
    var canAutomaticallySelectStop: Bool {
        globalStopsStateObject.isAutomaticWhenLocationIsAvailable
        && globalStopsStateObject.stops.count > 0
    }

    var body: some View {
        ContentView()
            .task {
                // Perform overall global data refresh
                await globalSystemsStateObject.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
            }
            .onChange(of: globalSystemsStateObject.selectedSystem) {
                guard let systemId = globalSystemsStateObject.selectedSystem?.id else {
                    // Account for cases where system ID does not exist due to
                    // lack of value in UserDefaults
                    Task {
                        setSelectionStateBasedOnLastTappedNotificationDetails()
                    }
                    return
                }
                
                Task {
                    let stopsNetworkArguments = GlobalStopsNetworkArguments(
                        systemId: systemId
                    )
                    await globalStopsStateObject.refreshDataOnce(arguments: stopsNetworkArguments)
                    
                    if canAutomaticallySelectStop {
                        tryAutomaticallySelectStop()
                    } else if globalStopsStateObject.stops.count > 0 {
                        globalStopsStateObject.selectStopId(globalStopsStateObject.stops[0].id)
                    }
                    
                    setSelectionStateBasedOnLastTappedNotificationDetails()
                }
            }
            .task {
                updateGlobalStopsStateAutomaticState()
            }
            .onChange(of: canAutomaticallySelectStop) {
                // Run on startup in addition to location changes
                tryAutomaticallySelectStop()
            }
            .onChange(of: locationManagerStateObject.lastUpdatedLocation) {
                tryAutomaticallySelectStop()
            }
            .onChange(of: notificationCenterDelegate.lastTappedNotificationDetails) {
                setSelectionStateBasedOnLastTappedNotificationDetails()
            }
    }
    
    func setSelectionStateBasedOnLastTappedNotificationDetails() {
        guard let details = notificationCenterDelegate.lastTappedNotificationDetails else { return }
        
        globalStopsStateObject.selectStopId(details.stopId)
        globalSystemsStateObject.selectSystemId(details.systemId)
        globalIdSelectionStateObject.selectedShuttleId = details.shuttleId
        
        notificationCenterDelegate.lastTappedNotificationDetails = nil
    }
    
    func tryAutomaticallySelectStop() {
        guard let location = locationManagerStateObject.lastUpdatedLocation else { return }
        
        if canAutomaticallySelectStop {
            globalStopsStateObject.selectClosestStopBasedOnLocation(location: location)
        }
    }
    
    func updateGlobalStopsStateAutomaticState() {
        if locationManagerStateObject.authorizationStatusInitialized {
            if locationManagerStateObject.isAuthorized {
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

