//
//  InterMVP0App.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import Apollo
import ProjectInterOperations
import SwiftData
import WebKit
import Combine
import ProjectInterShared
import ProjectInterLogging

@main
struct ProjectInterApp: App {
    @State var locationManagerStateObject = LocationDataModel()

    @State var globalIdSelectionStateObject = GlobalIdSelectionModel(routeIdSyncModel: RouteIdSelectionSyncModel())

    @State var globalSystemsStateObject = GlobalSystemsModel()

    @State var globalStopsStateObject = GlobalStopsModel()

    @State var setupStateModel = SetupStateModel()

    @State var serverUrlConfigModel = ServerUrlConfigurationModel()

    @State var schemaVersionModel = SchemaVersionModel(
        appSchemaVersion: Bundle.main.infoDictionary?["APP_SCHEMA_VERSION"] as? Int
    )

    /// Task consuming the schema-version polling stream.
    @State var schemaVersionUpdateTask: Task<Void, Error>? = nil
    
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
                            await refreshGlobalSystemsOnce()
                        }
                }
            }
            .task {
                restartSchemaVersionModelRefresh()
            }
            .onChange(of: serverUrlConfigModel.urlVersion) {
                restartSchemaVersionModelRefresh()
                Task {
                    await refreshGlobalSystemsOnce()
                }
            }
        }
        .environment(serverUrlConfigModel)
        .environment(globalIdSelectionStateObject)
        .environment(globalSystemsStateObject)
        .environment(globalStopsStateObject)
        .environment(locationManagerStateObject)
        .environmentObject(customAppDelegate.notificationCenterDelegate)
    }
    
    func restartSchemaVersionModelRefresh() {
        schemaVersionUpdateTask?.cancel()
        schemaVersionUpdateTask = Task {
            let query = SchemaVersionModel.convertNetworkArgumentsIntoQuery(SchemaVersionModelNetworkArguments())
            let stream = ApolloClient.shared.getStream(query, sleepDuration: .seconds(300))
            for await result in stream {
                await schemaVersionModel.injectUpdate(result)
            }
        }
    }

    /// One-off systems fetch, applied to the shared global systems model.
    @MainActor
    func refreshGlobalSystemsOnce() async {
        let query = GlobalSystemsModel.convertNetworkArgumentsIntoQuery(GlobalDataModelNetworkArguments())
        do {
            let response = try await ApolloClient.shared.fetch(query: query, cachePolicy: .networkOnly)
            if let data = response.data {
                await globalSystemsStateObject.injectUpdate(.success(data))
            }
        } catch {
            await globalSystemsStateObject.injectUpdate(.failure(error))
        }
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
                await refreshGlobalSystemsOnce()
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
                    await refreshGlobalStopsOnce(arguments: stopsNetworkArguments)
                    
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
        // In the future, if notifications support different types of arguments,
        // change this handling to be closer to that for URLs
        guard let details = notificationCenterDelegate.lastTappedNotificationDetails else { return }
        await handleOpenShuttleArguments(details)
        
        notificationCenterDelegate.lastTappedNotificationDetails = nil
    }
    
    private func setSelectionStateBasedOnUrl(_ url: URL) async {
        // See which object can handle the URL scheme correctly
        if let shuttleArguments = try? OpenShuttleArguments(url: url) {
            await handleOpenShuttleArguments(shuttleArguments)
        } else if let routeArguments = try? OpenRouteArguments(url: url) {
            handleOpenRouteArguments(routeArguments)
        } else if let parkingStructureArguments = try? OpenParkingStructureArguments(url: url) {
            handleOpenParkingStructureArguments(parkingStructureArguments)
        } else {
            Loggers.shared.systemEventsLogger.info("Failed to open received URL: \(url.absoluteString)")
        }
    }
    
    private func handleOpenRouteArguments(_ arguments: OpenRouteArguments) {
        globalStopsStateObject.selectStopId(arguments.stopId)
        globalSystemsStateObject.selectSystemId(arguments.systemId)
        globalIdSelectionStateObject.selectRouteId(arguments.routeId)
    }
    
    
    private func handleOpenParkingStructureArguments(_ arguments: OpenParkingStructureArguments) {
        globalSystemsStateObject.selectSystemId(arguments.systemId)
        globalIdSelectionStateObject.selectParkingStructureId(arguments.parkingStructureId)
    }
    
    private func handleOpenShuttleArguments(_ arguments: OpenShuttleArguments) async {
        globalStopsStateObject.selectStopId(arguments.stopId)
        globalSystemsStateObject.selectSystemId(arguments.systemId)
        await globalIdSelectionStateObject.autoSelectRouteIdFromShuttleId(.init(
            systemId: arguments.systemId,
            shuttleId: arguments.shuttleId
        ))
    }
    
    /// One-off systems fetch, applied to the shared global systems model.
    @MainActor
    func refreshGlobalSystemsOnce() async {
        let query = GlobalSystemsModel.convertNetworkArgumentsIntoQuery(GlobalDataModelNetworkArguments())
        do {
            let response = try await ApolloClient.shared.fetch(query: query, cachePolicy: .networkOnly)
            if let data = response.data {
                await globalSystemsStateObject.injectUpdate(.success(data))
            }
        } catch {
            await globalSystemsStateObject.injectUpdate(.failure(error))
        }
    }

    /// One-off stops fetch, applied to the shared global stops model.
    @MainActor
    func refreshGlobalStopsOnce(arguments: GlobalStopsNetworkArguments) async {
        let query = GlobalStopsModel.convertNetworkArgumentsIntoQuery(arguments)
        do {
            let response = try await ApolloClient.shared.fetch(query: query, cachePolicy: .networkOnly)
            if let data = response.data {
                await globalStopsStateObject.injectUpdate(.success(data))
            }
        } catch {
            await globalStopsStateObject.injectUpdate(.failure(error))
        }
    }

    func automaticallySelectStop() {
        if let location = locationManagerStateObject.lastUpdatedLocation {
            globalStopsStateObject.automaticallySelectStop(for: location)
        } else {
            globalStopsStateObject.automaticallySelectStop()
        }
    }
}

