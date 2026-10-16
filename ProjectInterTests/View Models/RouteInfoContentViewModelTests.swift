//
//  RouteInfoContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations
import ProjectInterShared
import ApolloTestSupport
import ProjectInterTestMocks

class RouteInfoContentViewModelTestsMockData {
    static let defaultArguments = RouteInfoNetworkArguments(systemId: "1", stopId: "1", routeId: "1")

    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            route: .init(
                name: "Red Route",
                orderedStop: .init(
                    nextStop: .init(
                        stop: .init(
                            name: "Panther Village"
                        )
                    )
                ),
                shuttles: [
                    .init(
                        eta: .init(
                            secondsRemaining: 125
                        ),
                        id: "1",
                        name: "Shuttle 1"
                    ),
                    .init(
                        eta: .init(
                            secondsRemaining: 30
                        ),
                        id: "2",
                        name: "Shuttle 2"
                    )
                ]
            )
        )
    )

    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            route: .init(
                name: "Grey Route",
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
                            secondsRemaining: 30
                        ),
                        id: "1",
                        name: "Shuttle 1"
                    ),
                ]
            )
        )
    )

}

/// Tests for ``RouteInfoContentViewShuttle``.
class RouteInfoContentViewShuttleTests {
    @Test func testEstimatedTimeAwayDisplayForNoData() {
        let shuttle = RouteInfoContentViewShuttle(name: "Shuttle 1", id: "1")
        #expect(shuttle.estimatedTimeAwayDisplay == "N/A")
    }
    
    @Test func testEstimatedTimeAwayDisplayForUnderOneMinute() {
        let shuttle = RouteInfoContentViewShuttle(name: "Shuttle 1", secondsRemaining: 20, id: "1")
        #expect(shuttle.estimatedTimeAwayDisplay == "<1 min")
    }
    
    @Test func testEstimatedTimeAwayDisplayForAboveOneMinute() {
        let shuttle = RouteInfoContentViewShuttle(name: "Shuttle 1", secondsRemaining: 120, id: "1")
        #expect(shuttle.estimatedTimeAwayDisplay == "2 min")
    }
    
    @Test func testApolloDataInitializerInitializesData() async {
        let data = await GetRouteInfoDataQuery.Data.from(RouteInfoContentViewModelTestsMockData.defaultMock)
        let shuttles = data.system!.route!.shuttles!
        
        let constructedShuttles = shuttles.map(RouteInfoContentViewShuttle.init)
        
        for i in 0..<constructedShuttles.count {
            #expect(ETASeconds(shuttles[i].eta!.secondsRemaining) == constructedShuttles[i].secondsRemaining)
            #expect(shuttles[i].name == constructedShuttles[i].name)
            #expect(shuttles[i].id == constructedShuttles[i].id)
        }
    }
}

class RouteInfoContentViewModelTests {
    let networkArguments = RouteInfoContentViewModelTestsMockData.defaultArguments
    let defaultMock = RouteInfoContentViewModelTestsMockData.defaultMock

    @Test("injectUpdate maps route name, next stop, and shuttles") func injectUpdateMapsRouteInfo() async {
        let viewModel = RouteInfoContentView<ShuttleInfoContentView>.ViewModel()
        let data = await GetRouteInfoDataQuery.Data.from(defaultMock)

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 2)
    }

    @Test func sortsShuttlesBySecondsRemaining() async {
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                route: .init(
                    name: "Red Route",
                    orderedStop: .init(
                        nextStop: .init(
                            stop: .init(
                                name: "Panther Village"
                            )
                        )
                    ),
                    shuttles: [
                        .init(
                            id: "3",
                            name: "Shuttle 3"
                        ),
                        .init(
                            eta: .init(
                                secondsRemaining: 125
                            ),
                            id: "1",
                            name: "Shuttle 1"
                        ),
                        .init(
                            eta: .init(
                                secondsRemaining: 30
                            ),
                            id: "2",
                            name: "Shuttle 2"
                        )
                    ]
                )
            )
        )

        let viewModel = RouteInfoContentView<ShuttleInfoContentView>.ViewModel()
        let data = await GetRouteInfoDataQuery.Data.from(mock)
        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.shuttles.count == 3)
        #expect(viewModel.shuttles[0].secondsRemaining == 30)
        #expect(viewModel.shuttles[1].secondsRemaining == 125)
        #expect(viewModel.shuttles[2].secondsRemaining == nil)
    }
}
