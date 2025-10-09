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

struct ParkingStructuresWidgetEntry: ExtendedTimelineEntry, GraphQLConstructable {
    typealias Query = GetParkingStructuresListDataQuery
    
    let systemId: String?
    let date: Date
    let parkingStructures: [ParkingStructure]?
    let status: TimelineEntryStatus
    
    static func create(_ query: ProjectInterOperations.GetParkingStructuresListDataQuery, client: ApolloClientProtocol = ApolloClient.shared) async throws -> ParkingStructuresWidgetEntry {
        let systemId = query.systemId
        let result = try await getGraphQLResult(query, client: client)
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

