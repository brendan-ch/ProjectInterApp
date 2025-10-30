//
//  ParkingStructuresWidgetEntryTests.swift
//  ProjectInterWidgetsCore
//
//  Created by Brendan Chen on 2025.10.29.
//

import Testing
import ProjectInterShared
import ProjectInterOperations
import ProjectInterTestMocks
@testable import ProjectInterWidgetsCore

class ParkingStructuresWidgetEntryTests {
    @Test("ParkingStructuresWidgetEntry creates correctly with correct data")
    func parkingStructuresWidgetCreates() async throws {
        let mockClient = MockApolloClient()
        mockClient.queryMock = .init(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: .init(
                        address: "123 Test Address",
                        capacity: 100,
                        historicalAverages: nil,
                        id: "1",
                        name: "Test Structure",
                        spotsAvailable: 150,
                    )
                )
            )
        )
        
        let query = GetParkingStructureInfoDataQuery(systemId: "1", parkingStructureId: "1", historicalAveragesInput: nil)
        
        let entry = try await ParkingStructureWidgetEntry.create(
            query,
            client: mockClient,
        )
        #expect(entry.parkingStructure?.name == "Test Structure")
        #expect(entry.parkingStructure?.capacity == 100)
        #expect(entry.parkingStructure?.id == "1")
    }
}
