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

public struct ParkingStructuresWidgetEntry: ProjectInterTimelineEntry, GraphQLConstructable {
    public typealias Query = GetParkingStructuresListDataQuery
    
    public init(systemId: String?, date: Date, parkingStructures: [ParkingStructure]?, status: TimelineEntryStatus) {
        self.systemId = systemId
        self.date = date
        self.parkingStructures = parkingStructures
        self.status = status
    }
    
    public let systemId: String?
    public let date: Date
    public let parkingStructures: [ParkingStructure]?
    public let status: TimelineEntryStatus
    
    public static func create(_ query: ProjectInterOperations.GetParkingStructuresListDataQuery, client: ApolloClient = ApolloClient.shared) async throws -> ParkingStructuresWidgetEntry {
        let systemId = query.systemId
        let result = try await getGraphQLResult(query, client: client)
        guard let data = result.data else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        return try create(systemId: systemId, data: data)
    }

    /// Pure construction from fetched data; the network fetch above is a thin wrapper.
    public static func create(systemId: String?, data: GetParkingStructuresListDataQuery.Data) throws -> ParkingStructuresWidgetEntry {
        guard let structures = data.system?.parkingSystem?.parkingStructures else {
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
