//
//  ParkingStructureWidgetEntryTests.swift
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

class ParkingStructureWidgetEntryTests {
    @Test("ParkingStructureWidgetEntry creates correctly with correct data")
    func parkingStructureWidgetCreates() async throws {
        let mock = Mock<ProjectInterTestMocks.Query>(
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

        let data = await GetParkingStructureInfoDataQuery.Data.from(mock)

        let entry = try ParkingStructureWidgetEntry.create(systemId: "1", data: data)
        #expect(entry.parkingStructure?.name == "Test Structure")
        #expect(entry.parkingStructure?.capacity == 100)
        #expect(entry.parkingStructure?.id == "1")
        #expect(entry.parkingStructure?.spotsAvailable == 150)
    }
}
