//
//  ParkingStructuresWidgetTimelineProvider.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.08.
//

import ProjectInterShared
import ProjectInterWidgetsCore
import WidgetKit
import ProjectInterOperations

struct ParkingStructuresWidgetTimelineProvider: UserDefaultsAppIntentTimelineProvider {
    typealias Entry = ParkingStructuresWidgetEntry
    typealias Intent = ParkingStructuresWidgetConfigurationAppIntent
    
    internal let userDefaults: UserDefaults?
    
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
            systemId: "1",
            date: .now,
            parkingStructures: [
                .mock,
                .mock,
                .mock
            ],
            status: .succeeded,
        )
    }
    
    func timeline(for configuration: ParkingStructuresWidgetConfigurationAppIntent, in context: Context) async -> Timeline<ParkingStructuresWidgetEntry> {
        let systemId = configuration.getSystemId(userDefaults: userDefaults)
        
        if !setupCompleted {
            return timelineForFailingEntryWithError(error: "To see parking structures, complete app setup.")
        }
        
        guard let systemId = systemId,
              let entry = try? await ParkingStructuresWidgetEntry.create(GetParkingStructuresListDataQuery(systemId: systemId)) else {
            return timelineForFailingEntryWithError(error: "Unable to get parking structures; please try again later.")
        }
        
        return timelineForEntry(entry)
    }
    
    func timelineForFailingEntryWithError(error: String) -> Timeline<ParkingStructuresWidgetEntry> {
        return timelineForEntry(.init(
            systemId: nil,
            date: .now,
            parkingStructures: nil,
            status: .failed(error: error)
        ))
    }
    
    func timelineForEntry(_ entry: ParkingStructuresWidgetEntry) -> Timeline<ParkingStructuresWidgetEntry> {
        return timelineForEntries([entry])
    }
    
    func timelineForEntries(_ entries: [ParkingStructuresWidgetEntry]) -> Timeline<ParkingStructuresWidgetEntry> {
        return Timeline(entries: entries, policy: .atEnd)
    }
}
