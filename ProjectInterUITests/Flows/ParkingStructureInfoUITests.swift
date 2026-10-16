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
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
        selectDefaultSystem()
    }
    
    
    func mockGetParkingStructureDataWithHistorical() async {
        let now = Date()
        let query = GetParkingStructureInfoDataQuery(
            systemId: defaultSystemId,
            parkingStructureId: "1",
            historicalAveragesInput: .init(.init(
                from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
                intervalMs: 1000 * 60 * 60 * 2
            ))
        )
        
        let response = Mock<Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: .init(
                        address: "300 E Walnut Ave, Orange, CA 92867 United States",
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
    
    func selectMockParkingStructure() {
        let parkingStructureText = app.staticTexts["Anderson"]
        XCTAssert(parkingStructureText.waitForExistence(timeout: 10))
        parkingStructureText.tap()
    }
    
    @MainActor
    func testParkingStructureInfoDisplayWithHistorical() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructureDataWithHistorical()
        launchAppAndResetCustomServerUrl()
        
        switchToParkingTab()
        selectMockParkingStructure()
        
        XCTAssert(app.staticTexts["20 available"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["80/100"].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testParkingStructureInfoDisplayWithoutHistorical() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructureDataWithoutHistorical()
        launchAppAndResetCustomServerUrl()
        
        switchToParkingTab()
        selectMockParkingStructure()

        XCTAssert(app.staticTexts["No historical data available. Check back later."].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testParkingStructureInfoAddressIsCopyable() async {
        // only assert that the button is tappable, not that the
        // data actually ends up in the pasteboard
        
        await mockGetParkingStructuresListData()
        await mockGetParkingStructureDataWithoutHistorical()
        launchAppAndResetCustomServerUrl()

        switchToParkingTab()
        selectMockParkingStructure()
        

        let copyAddressButton = app.buttons["Copy address"]
        XCTAssert(copyAddressButton.waitForExistence(timeout: 10))
        copyAddressButton.tap()
    }

}
