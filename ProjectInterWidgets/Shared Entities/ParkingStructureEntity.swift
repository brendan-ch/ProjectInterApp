//
//  ParkingStructureEntity.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.21.
//

import WidgetKit
import Apollo
import AppIntents
import ProjectInterShared
import ProjectInterOperations

struct ParkingStructureEntity: AppEntity, Identifiable {
    typealias Query = GetParkingStructuresListDataQuery
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Option"
    static var defaultQuery = ParkingStructureEntityQuery()

    let id: String
    let name: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct ParkingStructureEntityQuery: EntityStringQuery {
    // Inject the entire intent into the query
    // See https://stackoverflow.com/questions/76754804/display-appentity-results-depending-on-the-selection-of-a-parameter-in-appintent
    @IntentParameterDependency<ParkingStructureWidgetConfigurationAppIntent>(
        \.$system
    )
    var intent
    
    func defaultResult() async -> ParkingStructureEntity? {
        return ParkingStructureEntity(id: "-1", name: "Select a parking structure")
    }
    
    func entities(matching query: String) async throws -> [ParkingStructureEntity] {
        let all = await allOptions()
        return all.filter {
            $0.name.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func entities(for identifiers: [ParkingStructureEntity.ID]) async throws -> [ParkingStructureEntity] {
        await allOptions().filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [ParkingStructureEntity] {
        await allOptions()
    }
    
    private func allOptions() async -> [ParkingStructureEntity] {
        if let id = intent?.getSystemId(),
           let provider = try? await ParkingStructuresProvider.create(GetParkingStructuresListDataQuery(systemId: id)) {
            return provider.parkingStructures
        }
        return []
    }
}

struct ParkingStructuresProvider: GraphQLConstructable {
    let parkingStructures: [ParkingStructureEntity]
    
    static func create(_ query: ProjectInterOperations.GetParkingStructuresListDataQuery, client: ApolloClient = ApolloClient.shared) async throws -> ParkingStructuresProvider {
        let result = try await getGraphQLResult(query, client: client)
        guard let data = result.data else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        guard let parkingStructures = data.system?.parkingSystem?.parkingStructures else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        
        return .init(
            parkingStructures: parkingStructures.map { parkingStructure in
                .init(
                    id: parkingStructure.id,
                    name: parkingStructure.name,
                )
            }
        )
    }
}

