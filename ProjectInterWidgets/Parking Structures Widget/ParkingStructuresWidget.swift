//
//  ParkingStructureWidget.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import WidgetKit
import SwiftUI
import ProjectInterShared
import Apollo
import ProjectInterOperations

struct ParkingStructuresWidgetTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = ParkingStructuresWidgetEntry
    typealias Intent = ParkingStructuresWidgetConfigurationAppIntent
    
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
           let systemIdFromUserDefaults = UserDefaults.group?.string(forKey: UserDefaults.selectedSystemIdKey) {
            systemId = systemIdFromUserDefaults
        }
        
        guard let setupCompleted = UserDefaults.group?.bool(forKey: UserDefaults.setupCompletedKey),
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

struct ParkingStructuresWidgetEntry: ExtendedTimelineEntry, GraphQLConstructable {
    typealias Query = GetParkingStructuresListDataQuery
    
    let systemId: String?
    let date: Date
    let parkingStructures: [ParkingStructure]?
    let status: TimelineEntryStatus
    
    static func create(_ query: ProjectInterOperations.GetParkingStructuresListDataQuery) async throws -> ParkingStructuresWidgetEntry {
        let systemId = query.systemId
        let result = try await getGraphQLResult(query)
        guard let structures = result.data?.system?.parkingSystem?.parkingStructures else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        return .init(
            systemId: systemId,
            date: .now,
            parkingStructures: structures.map { structure in
                .init(
                    id: structure.id,
                    name: structure.name,
                    capacity: structure.capacity,
                    spotsAvailable: structure.spotsAvailable
                )
            },
            status: .succeeded
        )
    }
}


struct ParkingStructuresWidget: Widget {
    let kind: String = "ParkingStructuresWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ParkingStructuresWidgetConfigurationAppIntent.self, provider: ParkingStructuresWidgetTimelineProvider())  { entry in
            if #available(iOS 17.0, *) {
                ParkingStructuresWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ParkingStructuresWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Parking Structures")
        .description("View parking structures for the selected system.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

