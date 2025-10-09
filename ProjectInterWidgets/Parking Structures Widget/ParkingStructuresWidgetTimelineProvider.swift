//
//  ParkingStructuresWidgetTimelineProvider.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.08.
//

import ProjectInterShared
import WidgetKit
import ProjectInterOperations

struct ParkingStructuresWidgetTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = ParkingStructuresWidgetEntry
    typealias Intent = ParkingStructuresWidgetConfigurationAppIntent
    
    private let userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults? = .group) {
        self.userDefaults = userDefaults
    }
    
    func placeholder(in context: Context) -> ParkingStructuresWidgetEntry {
        return .init(
            systemId: nil,
            date: .now,
            parkingStructures: [
                .mock
            ],
            status: .succeeded,
        )
    }
    
    func snapshot(for configuration: ParkingStructuresWidgetConfigurationAppIntent, in context: Context) async -> ParkingStructuresWidgetEntry {
        return .init(
            systemId: nil,
            date: .now,
            parkingStructures: [
                .mock
            ],
            status: .succeeded,
        )
    }
    
    func timeline(for configuration: ParkingStructuresWidgetConfigurationAppIntent, in context: Context) async -> Timeline<ParkingStructuresWidgetEntry> {
        var systemId = configuration.system?.id
        if configuration.mirrorSystemInApp,
           let systemIdFromUserDefaults = userDefaults?.string(forKey: UserDefaults.selectedSystemIdKey) {
            systemId = systemIdFromUserDefaults
        }
        
        guard let setupCompleted = userDefaults?.bool(forKey: UserDefaults.setupCompletedKey),
              setupCompleted else {
            return constructTimelineFromEntries(entries: [.init(
                systemId: nil,
                date: .now,
                parkingStructures: nil,
                status: .failed(error: "To see parking structures, complete app setup.")
            )])
        }
        
        guard let systemId = systemId,
              let entry = try? await ParkingStructuresWidgetEntry.create(GetParkingStructuresListDataQuery(systemId: systemId)) else {
            return constructTimelineFromEntries(entries: [.init(
                systemId: nil,
                date: .now,
                parkingStructures: nil,
                status: .failed(error: "Unable to get parking structures; please try again later.")
            )])
        }
        
        return constructTimelineFromEntries(entries: [entry])
    }
    
    func constructTimelineFromEntries(entries: [ParkingStructuresWidgetEntry]) -> Timeline<ParkingStructuresWidgetEntry> {
        return Timeline(entries: entries, policy: .atEnd)
    }
}
