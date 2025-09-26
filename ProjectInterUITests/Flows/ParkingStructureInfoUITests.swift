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
    
    /// Launch and set up Apple Maps at the beginning of the test, so pop-ups
    /// don't interrupt the testing flow later.
    func setupMapsApp() {
        let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Allow Maps to use your location") { alertElement in
            let allowButton = alertElement.buttons["Allow While Using App"]
            if allowButton.waitForExistence(timeout: 10) {
                allowButton.tap()
                return true
            }
            
            return false
        }
        
        let mapsApp = XCUIApplication(bundleIdentifier: "com.apple.Maps")
        mapsApp.activate()
        mapsApp.swipeUp()
        
        // Can appear during setup
        let notificationRequestDismissButton = mapsApp.buttons["Not Now"]
        if notificationRequestDismissButton.waitForExistence(timeout: 20) {
            notificationRequestDismissButton.tap()
        }
        let hikesCustomRoutesButton = mapsApp.buttons["Continue"]
        if hikesCustomRoutesButton.waitForExistence(timeout: 20) {
            hikesCustomRoutesButton.tap()
        }
        
        removeUIInterruptionMonitor(locationDialogMonitor)
        
        activateSpringboard()
    }
    
    func setupGoogleMapsWebsite() {
        let mobilesafariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        mobilesafariApp.activate()
        
        let element = mobilesafariApp/*@START_MENU_TOKEN@*/.textFields["TabBarItemTitle"]/*[[".otherElements",".textFields[\"Address\"]",".textFields[\"Search or enter website\"]",".textFields[\"TabBarItemTitle\"]",".textFields"],[[[-1,3],[-1,2],[-1,1],[-1,4],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element.tap()
        
        mobilesafariApp.typeText("maps.google.com")
        mobilesafariApp.typeKey(XCUIKeyboardKey.enter, modifierFlags: [])
        mobilesafariApp/*@START_MENU_TOKEN@*/.buttons["Go"]/*[[".otherElements",".buttons[\"go\"]",".buttons[\"Go\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let dismissButton = mobilesafariApp.buttons["Go back to web"]
        if dismissButton.waitForExistence(timeout: 20) {
            dismissButton.tap()
        }
        
        activateSpringboard()
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
        await mockGetParkingStructureDataWithoutHistorical()
        app.launch()
        
        switchToParkingTab()
        selectMockParkingStructure()

        XCTAssert(app.staticTexts["No historical data available. Check back later."].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testParkingStructureInfoCopyAddressCopiesTheAddress() async {
        await mockGetParkingStructuresListData()
        await mockGetParkingStructureDataWithoutHistorical()
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
        await mockGetParkingStructureDataWithoutHistorical()
        
        setupMapsApp()
        
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
        await mockGetParkingStructureDataWithoutHistorical()
        
        setupGoogleMapsWebsite()
        
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
