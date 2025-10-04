//
//  SystemEntity.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import WidgetKit
import Apollo
import AppIntents
import ProjectInterShared
import ProjectInterOperations

struct SystemEntity: AppEntity, Identifiable {
    typealias Query = GetAllSystemsQuery
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Option"
    static var defaultQuery = SystemEntityQuery()
    
    let id: String
    let name: String?
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name ?? "Select a system")")
    }
    
}

struct SystemEntityQuery: EntityQuery {
    func entities(for identifiers: [SystemEntity.ID]) async throws -> [SystemEntity] {
        await allOptions().filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> some ResultsCollection {
        await allOptions()
    }
    
    private func allOptions() async -> [SystemEntity] {
        if let provider = try? await SystemsProvider.create(GetAllSystemsQuery()) {
            return provider.systems
        }
        return []
    }
}

struct SystemsProvider: GraphQLConstructable {
    let systems: [SystemEntity]
    
    static func create(_ query: ProjectInterOperations.GetAllSystemsQuery) async throws -> SystemsProvider {
        let result = try await getGraphQLResult(query)
        guard let data = result.data else {
            throw GraphQLConstructableError.dataNotAvailable
        }
        
        return .init(
            systems: data.systems.map { system in
                .init(
                    id: system.id,
                    name: system.name
                )
            }
        )
    }
}
