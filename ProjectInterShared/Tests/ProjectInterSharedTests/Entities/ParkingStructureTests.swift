//
//  ParkingStructureTests.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.11.14.
//

import Testing
@testable import ProjectInterShared
import ProjectInterOperations

@Suite("ParkingStructure")
class ParkingStructureTests {
    @Test("ParkingStructure.create creates data from GraphQL result")
    func parkingStructureCreatesFromGraphQLData() async throws {
        let expectedParkingStructure = ParkingStructure(
            id: "1",
            name: "Test Structure",
            capacity: 100,
            spotsAvailable: 150,
        )
        
        let mockClient = MockApolloClient()
        mockClient.queryMock = .init(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: .init(
                        address: "123 Test Address",
                        capacity: expectedParkingStructure.capacity,
                        historicalAverages: nil,
                        id: expectedParkingStructure.id,
                        name: expectedParkingStructure.name,
                        spotsAvailable: expectedParkingStructure.spotsAvailable,
                    ),
                )
            )
        )
        
        let query = GetParkingStructureInfoDataQuery(
            systemId: "1",
            parkingStructureId: "1",
            historicalAveragesInput: nil
        )
        
        let parkingStructure = try await ParkingStructure.create(query, client: mockClient)
        #expect(parkingStructure == expectedParkingStructure)
    }
}
