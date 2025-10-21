//
//  ParkingStructuresWidgetEntry.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import ProjectInterShared
import ProjectInterOperations
import Apollo

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
