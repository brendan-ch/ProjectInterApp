//
//  RouteInfoTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.24.
//

import XCTest
import ProjectInterOperations
import ProjectInterTestMocks
import ApolloTestSupport

final class RouteInfoUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    @MainActor
    func testShuttleInfoIsShownWhenTapped() async {
        let allStopsQuery = GetAllStopsBySystemIdQuery(systemId: defaultSystemId)
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
                    )
                ]
            )
        )
        await client.mock(query: allStopsQuery, response: allStopsResponse)
        
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
                        )
                    ]
                )
            )
        )
        
        await client.mock(query: routeListQuery, response: routeListResponse)
        
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
                                secondsRemaining: 50
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
        
        let shuttleInfoQuery = GetShuttleInfoDataQuery(
            systemId: defaultSystemId,
            shuttleId: "1",
            notificationInput: .init(
                deviceId: "1",
                shuttleId: "1",
                stopId: "1"
            )
        )
        let shuttleInfoResponse = Mock<Query>(
            secondsThresholdForNotification: 300,
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 50,
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
        
        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        selectFirstMatchButton(textIdentifier: "Shuttle 1")
        
        XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5))
    }
    
    func testRouteInfoIsClosedWhenCloseButtonTapped() {
        app.launch()
        
        var routeTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !checkIfRoutesExist() {
                return false
            }
            
            executeCallbackForEachRoute(shouldExitCallbackLoop: {
                routeTapped = true
                
                // Exit immediately to test the close button
                return true
            })
            
            let _ = app.buttons["Close"].waitForExistence(timeout: 5)
            app.buttons["Close"].tap()
            
            let routeInfoShuttlesNoLongerExist = app.buttons["Shuttle label in route info page"].waitForNonExistence(timeout: 5)
            XCTAssert(routeInfoShuttlesNoLongerExist)
            
            return true
        })
        
        if !routeTapped {
            XCTFail("No routes found in test data")
        }
    }
}
