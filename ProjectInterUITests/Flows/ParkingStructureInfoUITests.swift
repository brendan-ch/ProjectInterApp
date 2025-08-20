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
    let mockAddress = "300 E Walnut Ave, Orange, CA 92867 United States"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    func mockGetParkingStructuresDataWithoutHistorical() async {
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
                        address: mockAddress,
                        capacity: 100,
                        id: "1",
                        name: "Anderson",
                        spotsAvailable: 20
                    )
                )
            )
        )

        await client.mock(query: query, response: response)
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
        app.launch()
        
        switchToParkingTab()
        selectMockParkingStructure()
        
        XCTAssert(app.staticTexts["20 available"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["80/100"].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testParkingStructureInfoDisplayWithoutHistorical() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructuresDataWithoutHistorical()
        app.launch()
        
        switchToParkingTab()
        selectMockParkingStructure()

        let parkingStructureText = app.staticTexts["Anderson"]
        XCTAssert(parkingStructureText.waitForExistence(timeout: 10))
        parkingStructureText.tap()

        XCTAssert(app.staticTexts["No historical data available. Check back later."].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testParkingStructureInfoCopyAddressCopiesTheAddress() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructuresDataWithoutHistorical()
        app.launch()

        switchToParkingTab()
        selectMockParkingStructure()
        

        let copyAddressButton = app.buttons["Copy address"]
        XCTAssert(copyAddressButton.waitForExistence(timeout: 10))
        copyAddressButton.tap()
        
        // On a fresh simulator, we can't simply check the Pasteboard
        // because we would need to tap "Allow Paste" in the permissions dialog
        // However, we can't tap the dialog if this thread is blocked when
        // it's presented
        
        // Current solution is to launch another app and check if it pastes correctly
        
        let spotlightApp = XCUIApplication(bundleIdentifier: "com.apple.Spotlight")
        spotlightApp.activate()
        spotlightApp.textFields["Search"].firstMatch.tap()
        spotlightApp.textFields["Search"].firstMatch.tap()
        spotlightApp/*@START_MENU_TOKEN@*/.staticTexts["Paste"]/*[[".menuItems[\"Paste\"].staticTexts",".otherElements.staticTexts[\"Paste\"]",".staticTexts[\"Paste\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()

        let matchingElement = spotlightApp.otherElements.containing(NSPredicate(format: "label CONTAINS '300 E Walnut Ave'")).element
        XCTAssert(matchingElement.waitForExistence(timeout: 10))
        
        activateSpringboard()
    }
    
    @MainActor
    func testParkingStructureInfoOpensDirectionsInAppleMaps() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructuresDataWithoutHistorical()
        app.launch()
        
        switchToParkingTab()
        selectMockParkingStructure()

        let directionsButton = app.buttons["Directions"]
        XCTAssert(directionsButton.waitForExistence(timeout: 10))
        directionsButton.tap()
        
        let sheet = app.sheets["Select an app"]
        XCTAssert(sheet.waitForExistence(timeout: 10))
        sheet.buttons["Apple Maps"].tap()
        
        let mapsApp = XCUIApplication(bundleIdentifier: "com.apple.Maps")
        let expectedAddressText = mapsApp.staticTexts["300 E Walnut Ave"]
        XCTAssert(expectedAddressText.waitForExistence(timeout: 10))
        
        activateSpringboard()
    }
    
    @MainActor
    func testParkingStructureInfoOpensDirectionsInGoogleMaps() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructuresDataWithoutHistorical()
        app.launch()
        
        switchToParkingTab()
        selectMockParkingStructure()
        
        let directionsButton = app.buttons["Directions"]
        XCTAssert(directionsButton.waitForExistence(timeout: 10))
        directionsButton.tap()
        
        let sheet = app.sheets["Select an app"]
        XCTAssert(sheet.waitForExistence(timeout: 10))
        sheet.buttons["Google Maps"].tap()
        
        let mobilesafariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        let expectedAddressText = mobilesafariApp.staticTexts["300 E Walnut Ave"]
        XCTAssert(expectedAddressText.waitForExistence(timeout: 10))
        
        activateSpringboard()
    }

}
