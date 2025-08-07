//
//  ParkingStructureInfoUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.07.
//

import XCTest
import ProjectInterTestMocks
import ApolloTestSupport
import ProjectInterOperations

final class ParkingStructureInfoUITests: BaseUITests {
    let calendar = Calendar.current
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    func mockGetParkingStructureDataWithHistorical() async {
        let now = Date()
        let query = GetParkingStructureInfoDataQuery(
            systemId: defaultSystemId,
            parkingStructureId: "1",
            historicalAveragesInput: .init(
                from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
                intervalMs: 1000 * 60 * 60 * 2
            )
        )
        
        let response = Mock<Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: .init(
                        capacity: 100,
                        historicalAverages: [
                            .init(
                                averageSpotsAvailable: 50,
                                from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
                                to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!
                            ),
                            .init(
                                averageSpotsAvailable: 28,
                                from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                                to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
                            ),
                            .init(
                                averageSpotsAvailable: 15,
                                from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                                to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!
                            ),
                        ],
                        id: "1",
                        name: "Anderson",
                        spotsAvailable: 20
                    )
                )
            )
        )
        
        await client.mock(query: query, response: response)
    }
    
    @MainActor
    func testParkingStructureInfoDisplayWithHistorical() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructureDataWithHistorical()
        app.launch()
        
        let structuresButton = app.tabBars.buttons["Parking"]
        let parkingTabExists = structuresButton.waitForExistence(timeout: 10)
        XCTAssert(parkingTabExists)
        structuresButton.tap()
        
        let parkingStructureText = app.staticTexts["Anderson"]
        XCTAssert(parkingStructureText.waitForExistence(timeout: 10))
        parkingStructureText.tap()
        
        XCTAssert(app.staticTexts["20 available"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["80/100"].waitForExistence(timeout: 5))
    }
}
