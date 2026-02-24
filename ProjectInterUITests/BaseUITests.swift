//
//  InterMVP1UITests.swift
//  InterMVP1UITests
//
//  Created by Brendan Chen on 2024.12.16.
//

import XCTest
import Foundation
import ApolloTestSupport
import ProjectInterOperations
import ProjectInterTestMocks

struct ShuttleInfoQueryMockOptions {
    var secondsRemaining: Double
    var secondsThresholdForNotification: Int?
    var id: String
    
    init(secondsRemaining: Double = 150, secondsThresholdForNotification: Int? = nil, id: String = "1") {
        self.secondsRemaining = secondsRemaining
        self.secondsThresholdForNotification = secondsThresholdForNotification
        self.id = id
    }
}

class BaseUITests: XCTestCase {
    let calendar = Calendar.current
    var app: XCUIApplication = XCUIApplication()
    var client: MockServerClient = MockServerClient(url: .mockApiBaseUrl)
    
    /// For tests involving multiple systems, the information is stored here in order to
    /// construct mock requests involving system IDs.
    let mockSystems = [
        "1": "Chapman University",
        "2": "Cal State Long Beach"
    ]
    
    /// The user's selected system ID by default. Present regardless of whether
    /// testing one or multiple systems.
    var defaultSystemId: String {
        mockSystems.keys.first!
    }
    
    /// The user's selected system name by default. Present regardless of whether
    /// testing one or multiple systems.
    var defaultSystemName: String {
        mockSystems[defaultSystemId]!
    }

    // MARK: - Testing setup
    // MARK: Overrides
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        
        Task {
            await client.clear()
            await mockServerSchemaVersion()
            await mockSystems()
        }
        
        app.launchArguments += ["-uiTests", "1"]
    }
    
    // MARK: Launch arguments
    func skipSetupFlow() {
        // These launch arguments are automatically set in UserDefaults
        // https://sarunw.com/posts/how-to-set-userdefaults-value-with-launch-arguments/
        app.launchArguments += ["-setupCompleted", "1"]
    }
    
    func selectDefaultSystem() {
        app.launchArguments += ["-\(UserDefaults.initialSystemIdKey)", defaultSystemId]
    }
    
    func useMockNotificationsToken() {
        app.launchArguments += ["-mockNotificationsToken", "1"]
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - UI testing utilities
    func takeScreenshot() {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    // MARK: - UI testing reusable flows

    /// Resets the server URL to default if a custom one is configured.
    /// Does nothing if the "Change server URL" button is not present.
    func resetServerUrlIfNeeded() {
        let changeServerUrlButton = app.buttons["Change server URL"]
        guard changeServerUrlButton.waitForExistence(timeout: 5) else {
            return
        }
        changeServerUrlButton.tap()

        let resetButton = app.buttons["Reset to default"]
        guard resetButton.waitForExistence(timeout: 5) else {
            // No custom URL configured — dismiss the sheet
            let cancelButton = app.buttons["Cancel"]
            if cancelButton.waitForExistence(timeout: 5) {
                cancelButton.tap()
            }
            return
        }
        resetButton.tap()

        let saveButton = app.buttons["Save"]
        if saveButton.waitForExistence(timeout: 5) {
            saveButton.tap()
        }
    }

    func selectStopFromRouteList(name: String) {
        let _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
        
        XCTAssert(app.collectionViews.cells.staticTexts["No stops found."].waitForNonExistence(timeout: 5))
        
        let stopButton = app.buttons[name]
        let exists = stopButton.waitForExistence(timeout: 5)
        if !exists {
            XCTFail("Unable to find stop \(name)")
        }
        stopButton.tap()
    }
    
    func selectFirstMatchButton(textIdentifier: String) {
        let routeButton = app.buttons.containing(.staticText, identifier: textIdentifier).firstMatch
        let exists = routeButton.waitForExistence(timeout: 5)
        if !exists {
            XCTFail("Unable to find button with static text \(textIdentifier)")
        }
        routeButton.tap()
    }
    
    func executeCallbackForEachStop(shouldExitCallbackLoop: () -> Bool) {
        let _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
        
        XCTAssert(app.collectionViews.cells.staticTexts["No stops found."].waitForNonExistence(timeout: 5))
        
        let predicate = NSPredicate(format: "identifier BEGINSWITH 'StopSelectionCollectionSearchResultItem'")
        let sectionElements = app.buttons.matching(predicate).allElementsBoundByIndex
        
        for cell in sectionElements {
            cell.tap()
            
            let shouldExit = shouldExitCallbackLoop()
            if shouldExit {
                return
            }
            
            app.buttons["Change stop"].tap()
        }
    }
    
    func checkIfRoutesExist() -> Bool {
        let routes = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Route'"))
        let _ = routes.firstMatch.waitForExistence(timeout: 20)
        
        if !routes.allElementsBoundByIndex.isEmpty {
            return true
        }
        
        return false
    }
    
    func executeCallbackForEachRoute(shouldExitCallbackLoop: () -> Bool) {
        let routes = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Route'"))
        for route in routes.allElementsBoundByIndex {
            route.tap()
            
            let shouldExit = shouldExitCallbackLoop()
            if shouldExit {
                return
            }
            
            let _ = app.buttons["Close"].waitForExistence(timeout: 5)
            app.buttons["Close"].tap()
        }
    }

    func attemptToSelectShuttleButton() -> Bool {
        let firstMatchExists = app.otherElements.buttons["Shuttle"].waitForExistence(timeout: 5)
        if !firstMatchExists {
            return false
        }
        
        sleep(5)
        
        app.buttons["Shuttle"].firstMatch.forceTapElement()
        
        return true
    }
    
    func attemptToSelectParkingStructureButton() -> Bool {
        let firstMatchExists = app.otherElements.buttons["Parking structure"].waitForExistence(timeout: 5)
        if !firstMatchExists {
            return false
        }
        
        sleep(5)
        
        app.buttons["Parking structure"].firstMatch.forceTapElement()
        let shuttleTextExists = app.staticTexts["Parking structure name"].firstMatch.waitForExistence(timeout: 5)
        if !shuttleTextExists {
            app.buttons["Parking structure name"].firstMatch.forceTapElement()
        }
        
        return true
    }

    
    func executeCallbackForEachShuttle(shouldExitCallbackLoop: () -> Bool) {
        let shuttleButtons = app.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex
        
        for shuttle in shuttleButtons {
            let shuttleExists = shuttle.waitForExistence(timeout: 5)
            if !shuttleExists {
                continue
            }
            
            sleep(5)
            shuttle.forceTapElement()
            
            let shuttleTextExists = app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5)
            if !shuttleTextExists {
                // Try tapping again if the first attempt didn't work
                shuttle.forceTapElement()
                let _ = app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5)
            }
            
            let shouldExit = shouldExitCallbackLoop()
            if shouldExit {
                return
            }
            
            // Close the shuttle info view before trying the next shuttle
            let closeButton = app.buttons["Close"]
            if closeButton.waitForExistence(timeout: 5) {
                closeButton.tap()
            }
        }
    }
    
    func switchToParkingTab() {
        let structuresButton = app.tabBars.buttons["Parking"]
        let parkingTabExists = structuresButton.waitForExistence(timeout: 10)
        XCTAssert(parkingTabExists)
        structuresButton.tap()
    }
    
    /// For tests that check for something outside of the app, calling this is required
    /// to reset the device to its original state.
    func activateSpringboard() {
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboardApp.activate()
    }

    // MARK: - Mocks
    func mockServerSchemaVersion() async {
        let query = GetSchemaVersionQuery()
        let response = Mock<Query>(
            schemaCurrentVersion: 1,
            schemaMinVersion: 1
        )
        await client.mock(query: query, response: response)
    }
    
    func mockSystems() async {
        let systems = mockSystems.map { key, value in
            return Mock<System>(
                id: key,
                name: value
            )
        }
        
        let query = GetAllSystemsQuery()
        let response = Mock<Query>(
            systems: systems
        )
        await client.mock(query: query, response: response)
    }
    
    func mockGetAllStopsQueryAndResponse(systemId: String? = nil) async {
        let allStopsQuery = GetAllStopsBySystemIdQuery(systemId: systemId ?? defaultSystemId)
        let allStopsResponse = Mock<Query>(
            system: .init(
                stops: [
                    .init(
                        coordinates: .init(
                            // 33.79662° N, 117.88935° W
                            latitude: 33.79662,
                            longitude: -117.88935
                        ),
                        id: "1",
                        name: "Chapman Court",
                        orderedStops: [
                            .init(
                                routeId: "1"
                            ),
                            .init(
                                routeId: "2"
                            )
                        ]
                    ),
                    .init(
                        coordinates: .init(
                            // 33.79330° N, 117.85273° W
                            latitude: 33.79330,
                            longitude: -117.85273
                        ),
                        id: "2",
                        name: "Schmid Gate",
                        orderedStops: [
                            .init(
                                routeId: "3"
                            ),
                            .init(
                                routeId: "4"
                            )
                        ]
                    )
                ]
            )
        )
        await client.mock(query: allStopsQuery, response: allStopsResponse)
    }
    
    func mockGetRouteListQueryAndResponse() async {
        let routeListQuery = GetRouteListDataQuery(systemId: defaultSystemId, stopId: "1")
        let routeListResponse = Mock<Query>(
            system: .init(
                stop: .init(
                    name: "Chapman Court",
                    orderedStops: [
                        .init(
                            nextStop: .init(
                                stop: .init(
                                    name: "Chapman Grand"
                                )
                            ),
                            route: .init(
                                color: "#FF0000",
                                id: "1",
                                name: "Red Route",
                                shuttles: [
                                    .init(
                                        eta: .init(
                                            secondsRemaining: 50
                                        )
                                    ),
                                    .init(
                                        eta: .init(
                                            secondsRemaining: 130
                                        )
                                    )
                                ]
                            )
                        ),
                        .init(
                            nextStop: .init(
                                stop: .init(
                                    name: "Panther Village"
                                )
                            ),
                            route: .init(
                                color: "#0000FF",
                                id: "2",
                                name: "Blue Route",
                                shuttles: [
                                    .init(
                                        eta: .init(
                                            secondsRemaining: 150
                                        )
                                    ),
                                    .init(
                                        eta: .init(
                                            secondsRemaining: 130
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        )
        
        await client.mock(query: routeListQuery, response: routeListResponse)
    }
    
    func mockGetRouteInfoDataQueryAndResponse() async {
        let routeInfoQuery = GetRouteInfoDataQuery(systemId: defaultSystemId, stopId: "1", routeId: "1")
        let routeInfoResponse = Mock<Query>(
            system: .init(
                route: .init(
                    name: "Red Route",
                    orderedStop: .init(
                        nextStop: .init(
                            stop: .init(
                                name: "Chapman Grand"
                            )
                        )
                    ),
                    shuttles: [
                        .init(
                            eta: .init(
                                secondsRemaining: 150
                            ),
                            id: "1",
                            name: "Shuttle 1"
                        ),
                        .init(
                            eta: .init(
                                secondsRemaining: 130
                            ),
                            id: "2",
                            name: "Shuttle 2"
                        )
                    ]
                )
            )
        )
        await client.mock(query: routeInfoQuery, response: routeInfoResponse)
    }
    
    func mockShuttleInfoQueryAndResponse(_ options: ShuttleInfoQueryMockOptions) async {
        let shuttleInfoQuery = GetShuttleInfoDataQuery(
            systemId: defaultSystemId,
            shuttleId: options.id,
            notificationInput: .init(
                deviceId: "mock-device",
                shuttleId: options.id,
                stopId: "1"
            )
        )
        let shuttleInfoResponse = Mock<Query>(
            // Note that missing response properties are
            // automatically filled in by the server as `null`
            secondsThresholdForNotification: options.secondsThresholdForNotification,
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: options.secondsRemaining,
                            stop: .init(
                                id: "1",
                                name: "Chapman Court"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        await client.mock(query: shuttleInfoQuery, response: shuttleInfoResponse)
    }
    
    func mockGetParkingStructuresListData() async {
        let query = GetParkingStructuresListDataQuery(systemId: defaultSystemId)
        let response = Mock<Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructures: [
                        .init(
                            capacity: 100,
                            id: "1",
                            name: "Anderson",
                            spotsAvailable: 50
                        ),
                        .init(
                            capacity: 150,
                            id: "2",
                            name: "Barrera",
                            spotsAvailable: 100
                        )
                    ]
                )
            )
        )
        
        await client.mock(query: query, response: response)
    }
    
    func mockGetParkingStructureDataWithoutHistorical(parkingStructureId: String = "1") async {
        let mockAddress = "300 E Walnut Ave, Orange, CA 92867 United States"
        
        let now = Date()
        let query = GetParkingStructureInfoDataQuery(
            systemId: defaultSystemId,
            parkingStructureId: parkingStructureId,
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
                        address: mockAddress,
                        capacity: 100,
                        id: parkingStructureId,
                        name: "Anderson",
                        spotsAvailable: 20
                    )
                )
            )
        )
        
        await client.mock(query: query, response: response)
    }
}
