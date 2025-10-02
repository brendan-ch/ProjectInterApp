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
import ProjectInterLogging

@main
struct ProjectInterApp: App {
    @State var locationManagerStateObject = LocationDataModel()
    
    @State var globalIdSelectionStateObject = GlobalIdSelectionModel(routeIdSyncModel: RouteIdSelectionSyncModel(apolloNetworkModel: ApolloNetworkModelSingleton.shared.apolloNetworkModel))
    
    @State var globalSystemsStateObject = GlobalSystemsModel(apolloNetworkModel: ApolloNetworkModelSingleton.shared.apolloNetworkModel)
    
    @State var globalStopsStateObject = GlobalStopsModel(apolloNetworkModel: ApolloNetworkModelSingleton.shared.apolloNetworkModel)
    
    @State var globalNotificationsStateObject = ShuttleNotificationSchedulingModel(apolloClient: ApolloClientHolderSingleton.shared.apolloClient)
    
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

/// The content of the primary application, after the setup phase.
struct ContentViewWrapper: View {
    @Environment(GlobalSystemsModel.self) var globalSystemsStateObject: GlobalSystemsModel
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionStateObject: GlobalIdSelectionModel
    @Environment(GlobalStopsModel.self) var globalStopsStateObject: GlobalStopsModel
    @Environment(LocationDataModel.self) var locationManagerStateObject: LocationDataModel
    @EnvironmentObject var customAppDelegate: CustomAppDelegate
    @EnvironmentObject var notificationCenterDelegate: CustomNotificationCenterDelegate

    var body: some View {
        ContentView()
            .task {
                await globalSystemsStateObject.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
            }
            .onChange(of: globalSystemsStateObject.selectedSystem, initial: true) {
                guard let systemId = globalSystemsStateObject.selectedSystem?.id else {
                    // Account for cases where system ID does not exist due to
                    // lack of value in UserDefaults
                    Task {
                        await setSelectionStateBasedOnLastTappedNotificationDetails()
                    }
                    return
                }
                
                Task {
                    let stopsNetworkArguments = GlobalStopsNetworkArguments(
                        systemId: systemId
                    )
                    await globalStopsStateObject.refreshDataOnce(arguments: stopsNetworkArguments)
                    
                    automaticallySelectStop()
                    
                    await setSelectionStateBasedOnLastTappedNotificationDetails()
                }
            }
            .onChange(of: locationManagerStateObject.lastUpdatedLocation) {
                // If we're automatically selecting based on *location*,
                // we want to respect the user's override preferences if they have one
                if !globalStopsStateObject.stopSelectionManuallyOverridenByUser {
                    automaticallySelectStop()
                }
            }
            .onChange(of: notificationCenterDelegate.lastTappedNotificationDetails) {
                Task {
                    await setSelectionStateBasedOnLastTappedNotificationDetails()
                }
            }
            .onOpenURL { url in
                Loggers.shared.systemEventsLogger.info("App received URL: \(url.absoluteString)")
                Task {
                    await setSelectionStateBasedOnUrl(url)
                }
            }
    }
    
    func setSelectionStateBasedOnLastTappedNotificationDetails() async {
        guard let details = notificationCenterDelegate.lastTappedNotificationDetails else { return }
        
        globalStopsStateObject.selectStopId(details.stopId)
        globalSystemsStateObject.selectSystemId(details.systemId)
        await globalIdSelectionStateObject.autoSelectRouteIdFromShuttleId(.init(
            systemId: details.systemId,
            shuttleId: details.shuttleId
        ))
        
        notificationCenterDelegate.lastTappedNotificationDetails = nil
    }
    
    func setSelectionStateBasedOnUrl(_ url: URL) async {
        
    }
    
    func automaticallySelectStop() {
        if let location = locationManagerStateObject.lastUpdatedLocation {
            globalStopsStateObject.automaticallySelectStop(for: location)
        } else {
            globalStopsStateObject.automaticallySelectStop()
        }
    }
}

