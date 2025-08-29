//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import WebKit
import Combine

@main
struct ProjectInterApp: App {
    @State var locationManagerStateObject = GlobalLocationDataModel()
    
    @State var globalIdSelectionStateObject = GlobalIdSelectionModel()
    
    @State var globalSystemsStateObject = GlobalSystemsModel(apolloNetworkModel: ApolloNetworkModelSingleton.shared.apolloNetworkModel)
    
    @State var globalStopsStateObject = GlobalStopsModel(apolloNetworkModel: ApolloNetworkModelSingleton.shared.apolloNetworkModel)
    
    @State var globalNotificationsStateObject = GlobalNotificationSchedulingModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
    @State var setupStateModel = SetupStateModel()
    
    @State var schemaVersionModel = SchemaVersionModel(
        apolloNetworkModel: ApolloNetworkModelSingleton.shared.apolloNetworkModel,
        appSchemaVersion: Bundle.main.infoDictionary?["APP_SCHEMA_VERSION"] as? Int
    )
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var customAppDelegate: CustomAppDelegate
    
    var body: some Scene {
        WindowGroup {
            Group {
                let setupCompleted = setupStateModel.setupCompleted
                if !schemaVersionModel.compatibilityCheckCompleted {
                    ProgressView("Checking server status...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if !schemaVersionModel.isCompatible {
                    AppUpdateMessageView {
                        restartSchemaVersionModelRefresh()
                    }
                } else if setupCompleted {
                    ContentViewWrapper()
                } else {
                    WelcomeContentView()
                        .environment(setupStateModel)
                        .environmentObject(customAppDelegate)
                        .environment(globalSystemsStateObject)
                        .task {
                            await globalSystemsStateObject.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
                        }
                }
            }
            .task {
                restartSchemaVersionModelRefresh()
            }
        }
        .environment(globalIdSelectionStateObject)
        .environment(globalSystemsStateObject)
        .environment(globalStopsStateObject)
        .environment(locationManagerStateObject)
        .environment(globalNotificationsStateObject)
        .environmentObject(customAppDelegate.notificationCenterDelegate)
    }
    
    func restartSchemaVersionModelRefresh() {
        schemaVersionModel.stopRefreshingData()
        schemaVersionModel.startRefreshingData(arguments: SchemaVersionModelNetworkArguments(), sleepDuration: .seconds(300))
    }
    
}

struct ContentViewWrapper: View {
    @Environment(GlobalSystemsModel.self) var globalSystemsStateObject: GlobalSystemsModel
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionStateObject: GlobalIdSelectionModel
    @Environment(GlobalStopsModel.self) var globalStopsStateObject: GlobalStopsModel
    @Environment(GlobalLocationDataModel.self) var locationManagerStateObject: GlobalLocationDataModel
    @EnvironmentObject var customAppDelegate: CustomAppDelegate
    @EnvironmentObject var notificationCenterDelegate: CustomNotificationCenterDelegate
    
    var canAutomaticallySelectStop: Bool {
        globalStopsStateObject.isAutomaticWhenLocationIsAvailable
        && globalStopsStateObject.stops.count > 0
    }

    var body: some View {
        ContentView()
            .task {
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

