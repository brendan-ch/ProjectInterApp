//
//  MapViewUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.20.
//

import XCTest
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

final class MapUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    func mockGetMapDataQueryAndResponse() async {
        let query = GetMapDataQuery(systemId: defaultSystemId)
        let response = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                parkingSystem: .init(
                    parkingStructures: [
                        .init(
                            coordinates: .init(
                                latitude: 33.78793,
                                longitude: -117.86723
                            ),
                            id: "1",
                            name: "Anderson",
                        ),
                        .init(
                            coordinates: .init(
                                latitude: 33.79330,
                                longitude: -117.85296
                            ),
                            id: "2",
                            name: "Barrera",
                        )
                    ]
                ),
                routes: [
                    .init(
                        color: "#ff0000",
                        id: "1",
                        polylineCoordinates: Mock<Query>.mapRouteMock
                    ),
                    .init(
                        color: "#0000ff",
                        // To match the other stop
                        id: "3",
                        // For simplicity, just check that the color changed
                        polylineCoordinates: Mock<Query>.mapRouteMock
                    )
                ],
                shuttles: [
                    .init(
                        coordinates: Mock<Coordinates>(
                            // 33.78793° N, 117.86723° W
                            latitude: 33.78793,
                            longitude: -117.86723
                        ),
                        id: "1",
                        name: "Shuttle 1",
                        orientationInDegrees: 90.00,
                        route: Mock<Route>(
                            color: "#ff0000",
                            id: "1"
                        )
                    ),
                    .init(
                        coordinates: Mock<Coordinates>(
                            // 33.79330° N, 117.85296° W
                            latitude: 33.79330,
                            longitude: -117.85296
                        ),
                        id: "2",
                        name: "Shuttle 2",
                        orientationInDegrees: 90.00,
                        route: Mock<Route>(
                            color: "#ff0000",
                            id: "1"
                        )
                    )
                ],
                stops: [
                    .init(
                        coordinates: .init(
                            // 33.79646° N, 117.88941° W
                            latitude: 33.79646,
                            longitude: -117.88941
                        ),
                        id: "1",
                        name: "Chapman Court",
                        orderedStops: [
                            .init(
                                routeId: "1"
                            )
                        ]
                    ),
                    .init(
                        coordinates: .init(
                            // 33.79329° N, 117.85267° W
                            latitude: 33.79329,
                            longitude: -117.85267
                        ),
                        id: "2",
                        name: "Schmid Gate",
                        orderedStops: [
                            .init(
                                routeId: "1"
                            )
                        ]
                    )
                ]
            )
        )

        await client.mock(query: query, response: response)
    }
    
    @MainActor
    func testRouteIsShownWhenRouteIsSelected() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        
        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        
        takeScreenshot()
    }
    
    @MainActor
    func testRoutesAreChangedWhenSwitchingStops() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        
        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        takeScreenshot()

        selectStopFromRouteList(name: "Schmid Gate")
        takeScreenshot()
    }
    
    @MainActor
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        
        app.launch()
        selectStopFromRouteList(name: "Chapman Court")

        let shuttleExists = app.otherElements.buttons.matching(identifier: "Shuttle").firstMatch.waitForExistence(timeout: 20)
        XCTAssert(shuttleExists)
        
        var shuttleCounts: [Int] = []
        // When no routes are selected
        let totalShuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
        
        selectFirstMatchButton(textIdentifier: "Red Route")
        
        var shuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
        shuttleCounts.append(shuttleCount)

        let closeButton = app.buttons["Close"]
        let _ = closeButton.waitForExistence(timeout: 5)
        closeButton.tap()
        
        selectFirstMatchButton(textIdentifier: "Blue Route")

        shuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
        shuttleCounts.append(shuttleCount)
        
        var calculatedShuttleCount = 0
        for count in shuttleCounts {
            calculatedShuttleCount += count
        }
        XCTAssert(totalShuttleCount == calculatedShuttleCount)
    }
    
    @MainActor
    func testTapOnShuttleOpensShuttleInfo() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        await mockShuttleInfoQueryAndResponse(.init(
            id: "1"
        ))
        await mockShuttleInfoQueryAndResponse(.init(
            id: "2"
        ))

        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        
        XCTAssert(attemptToSelectShuttleButton())
        
        // Based on route info
        XCTAssert(app.staticTexts["Shuttle 1"].firstMatch.waitForExistence(timeout: 20))
        XCTAssert(app.staticTexts["Shuttle 2"].firstMatch.waitForExistence(timeout: 20))
    }
    
    @MainActor
    func testTapOnShuttleAfterDeselectOpensShuttleInfo() async {
        useMockNotificationsToken()

        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        await mockShuttleInfoQueryAndResponse(.init(
            id: "1"
        ))
        await mockShuttleInfoQueryAndResponse(.init(
            id: "2"
        ))

        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        
        XCTAssert(attemptToSelectShuttleButton())
        app.buttons["Close"].tap()
        XCTAssert(attemptToSelectShuttleButton())
        XCTAssert(app.staticTexts["Shuttle 1"].firstMatch.waitForExistence(timeout: 20))
        XCTAssert(app.staticTexts["Shuttle 2"].firstMatch.waitForExistence(timeout: 20))
    }
    
    @MainActor
    func testTapOnStopDeselectsShuttleAndHidesInfo() async {
        useMockNotificationsToken()

        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        await mockShuttleInfoQueryAndResponse(.init(
            id: "1"
        ))
        await mockShuttleInfoQueryAndResponse(.init(
            id: "2"
        ))

        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        
        XCTAssert(attemptToSelectShuttleButton())
        app.buttons["Stop"].firstMatch.tap()
        XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForNonExistence(timeout: 20))
    }
    
    @MainActor
    func testTapOnParkingStructureOpensParkingStructureInfo() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetMapDataQueryAndResponse()
        await mockGetParkingStructureDataWithoutHistorical(parkingStructureId: "1")
        await mockGetParkingStructureDataWithoutHistorical(parkingStructureId: "2")

        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        
        switchToParkingTab()
        
        XCTAssert(attemptToSelectParkingStructureButton())
        XCTAssert(app.staticTexts["Parking structure name"].firstMatch.waitForExistence(timeout: 20))
    }
}
