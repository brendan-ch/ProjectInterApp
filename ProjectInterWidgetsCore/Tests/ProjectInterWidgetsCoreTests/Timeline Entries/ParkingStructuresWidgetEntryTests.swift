//
//  ParkingStructuresWidgetEntryTests.swift
//  ProjectInterWidgetsCore
//
//  Created by Brendan Chen on 2025.10.29.
//

import Testing
import ApolloTestSupport
import ProjectInterShared
import ProjectInterOperations
import ProjectInterTestMocks
@testable import ProjectInterWidgetsCore

class ParkingStructuresWidgetEntryTests {
    @Test("ParkingStructuresWidgetEntry creates correctly with correct data")
    func parkingStructuresWidgetCreates() async throws {
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructures: [
                        .init(
                            address: "123 Test Address",
                            capacity: 100,
                            historicalAverages: nil,
                            id: "1",
                            name: "Test Structure",
                            spotsAvailable: 150,
                        ),
                        .init(
                            address: "456 Test Address",
                            capacity: 125,
                            historicalAverages: nil,
                            id: "2",
                            name: "Test Structure 2",
                            spotsAvailable: 150,
                        )
                    ]
                )
            )
        )

        let data = await GetParkingStructuresListDataQuery.Data.from(mock)

        let entry = try ParkingStructuresWidgetEntry.create(systemId: "1", data: data)
        #expect(entry.parkingStructures?.count == 2)
        #expect(entry.parkingStructures?[0].capacity == 100)
        #expect(entry.parkingStructures?[1].capacity == 125)
    }
}
