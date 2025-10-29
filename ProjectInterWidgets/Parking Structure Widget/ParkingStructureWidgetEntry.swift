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

struct ParkingStructureWidgetEntry: ProjectInterTimelineEntry, GraphQLConstructable {
    typealias Query = GetParkingStructureInfoDataQuery
    
    let systemId: String?
    let date: Date
    let parkingStructure: ParkingStructure?
    let status: TimelineEntryStatus
    
    static func create(
        _ query: GetParkingStructureInfoDataQuery,
        client: ApolloClientProtocol = ApolloClient.shared
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
