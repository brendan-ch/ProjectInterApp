//
//  ParkingStructureWidgetEntry.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import ProjectInterShared
import ProjectInterOperations
import Apollo

public struct ParkingStructureWidgetEntry: ProjectInterTimelineEntry, GraphQLConstructable {
    public typealias Query = GetParkingStructureInfoDataQuery
    
    public init(systemId: String?, date: Date, parkingStructure: ParkingStructure?, status: TimelineEntryStatus) {
        self.systemId = systemId
        self.date = date
        self.parkingStructure = parkingStructure
        self.status = status
    }
    
    public let systemId: String?
    public let date: Date
    public let parkingStructure: ParkingStructure?
    public let status: TimelineEntryStatus
    
    public static func create(
        _ query: GetParkingStructureInfoDataQuery,
        client: ApolloClient = ApolloClient.shared
    ) async throws -> ParkingStructureWidgetEntry {
        let systemId = query.systemId
        let result = try await getGraphQLResult(
            query,
            client: client
        )
        guard let structure = result.data?.system?.parkingSystem?.parkingStructure else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        
        return .init(
            systemId: systemId,
            date: .now,
            // TODO: Move the GraphQL-based initializer down
            parkingStructure: ParkingStructure(
                id: structure.id,
                name: structure.name,
                capacity: structure.capacity,
                spotsAvailable: structure.spotsAvailable
            ),
            status: .succeeded,
        )
    }
}
