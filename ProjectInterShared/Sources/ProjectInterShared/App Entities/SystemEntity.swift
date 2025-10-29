//
//  SystemEntity.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import Apollo
import AppIntents
import ProjectInterOperations

/// Representation of a system that is exposed to Apple platform experiences like
/// widgets and Shortcuts.
public struct SystemEntity: AppEntity, Identifiable {
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    typealias Query = GetAllSystemsQuery
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Option"
    public static var defaultQuery = SystemEntityQuery()
    
    public let id: String
    public let name: String
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
}

public struct SystemEntityQuery: EntityStringQuery {
    public init() {}
    
    public func defaultResult() async -> SystemEntity? {
        return SystemEntity(id: "-1", name: "Select a system")
    }
    
    public func entities(matching query: String) async throws -> [SystemEntity] {
        let all = await allOptions()
        return all.filter { $0.name.localizedCaseInsensitiveContains(query) == true }
    }
    
    public func entities(for identifiers: [SystemEntity.ID]) async throws -> [SystemEntity] {
        await allOptions().filter { identifiers.contains($0.id) }
    }
    
    public func suggestedEntities() async throws -> [SystemEntity] {
        await allOptions()
    }
    
    private func allOptions() async -> [SystemEntity] {
        if let provider = try? await SystemsProvider.create(GetAllSystemsQuery()) {
            return provider.systems
        }
        return []
    }
}

public struct SystemsProvider: GraphQLConstructable {
    let systems: [SystemEntity]
    
    public static func create(_ query: ProjectInterOperations.GetAllSystemsQuery, client: ApolloClientProtocol = ApolloClient.shared) async throws -> SystemsProvider {
        let result = try await getGraphQLResult(query, client: client)
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
