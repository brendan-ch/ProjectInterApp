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
        let route = Mock<ProjectInterTestMocks.Route>(
            color: "#ff0000",
            id: "1",
            polylineCoordinates: Mock<Query>.mapRouteMock,
        )
        let shuttle = Mock<ProjectInterTestMocks.Shuttle>(
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
        )

        
        let query = GetMapDataQuery(systemId: defaultSystemId)
        let response = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                routes: [
                    route
                ],
                shuttles: [
                    shuttle
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
        await mockGetMapDataQueryAndResponse()
        
        app.launch()
        
        
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !checkIfRoutesExist() {
                return false
            }
            
            executeCallbackForEachRoute(shouldExitCallbackLoop: {
                let screenshot = XCUIScreen.main.screenshot()
                let attachment = XCTAttachment(screenshot: screenshot)
                attachment.lifetime = .keepAlways
                add(attachment)
                
                // Run for every route
                return false
            })
            
            return true
        })
    }
    
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            var shuttleCounts: [Int] = []
            let totalShuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
            
            if !checkIfRoutesExist() {
                return false
            }
            
            executeCallbackForEachRoute(shouldExitCallbackLoop: {
                let shuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
                shuttleCounts.append(shuttleCount)
                
                return false
            })
            
            var calculatedShuttleCount = 0
            for count in shuttleCounts {
                calculatedShuttleCount += count
            }
            XCTAssert(totalShuttleCount == calculatedShuttleCount)
            
            return true
        })
    }
    
    func testTapOnShuttleOpensShuttleInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !attemptToSelectShuttleButton() {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
            shuttleButtonTapped = true
            return true
        })
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
    
    func testTapOnShuttleAfterDeselectOpensShuttleInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !attemptToSelectShuttleButton() {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
            shuttleButtonTapped = true
            
            app.buttons["Close"].tap()
            
            if !attemptToSelectShuttleButton() {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))

            return true
        })
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
    
    func testTapOnStopDeselectsShuttleAndHidesInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !attemptToSelectShuttleButton() {
                return false
            }

            let firstMatchStopButtonExists = app.otherElements.buttons["Stop"].waitForExistence(timeout: 20)
            if !firstMatchStopButtonExists {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
            shuttleButtonTapped = true

            app.buttons["Stop"].firstMatch.tap()
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForNonExistence(timeout: 20))
            
            return true
        })
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
}
