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
        #expect(shuttle.estimatedTimeAwayDisplay == "Less than 1 minute")
    }
    
    @Test func testEstimatedTimeAwayDisplayForAboveOneMinute() {
        let shuttle = RouteInfoContentViewShuttle(name: "Shuttle 1", secondsRemaining: 120, id: "1")
        #expect(shuttle.estimatedTimeAwayDisplay == "2 min")
    }
    
    @Test func testApolloDataInitializerInitializesData() {
        let data = GetRouteInfoDataQuery.Data.from(RouteInfoContentViewModelTestsMockData.defaultMock)
        let shuttles = data.system!.route!.shuttles!
        
        let constructedShuttles = shuttles.map(RouteInfoContentViewShuttle.init)
        
        for i in 0..<constructedShuttles.count {
            #expect(shuttles[i].eta?.secondsRemaining == constructedShuttles[i].secondsRemaining)
            #expect(shuttles[i].name == constructedShuttles[i].name)
            #expect(shuttles[i].id == constructedShuttles[i].id)
        }
    }
}

class RouteInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let networkArguments = RouteInfoContentViewModelTestsMockData.defaultArguments
    let defaultMock = RouteInfoContentViewModelTestsMockData.defaultMock
    let secondaryMock = RouteInfoContentViewModelTestsMockData.secondaryMock
    
    func assertViewModelDataForDefaultMock(viewModel: RouteInfoContentView.ViewModel) {
        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 2)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: RouteInfoContentView.ViewModel) {
        #expect(viewModel.routeName == "Grey Route")
        #expect(viewModel.routeNextStopName == "Chapman Grand")
        #expect(viewModel.shuttles.count == 1)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: RouteInfoContentView.ViewModel) {
        #expect(viewModel.routeName == "")
        #expect(viewModel.routeNextStopName == nil)
        #expect(viewModel.shuttles.count == 0)
    }
    
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        await autoTest_startRefreshingDataRefreshesDataOnFirstCall()
    }
    

    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        await autoTest_startRefreshingDataRefreshesDataMultipleTimes()
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        await autoTest_stopRefreshingDataStopsDataUpdatesAfterCompletion()
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        await autoTest_refreshDataOnceUpdatesData()
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        await autoTest_refreshDataOnceDoesNothingIfNoData()
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        await autoTest_refreshDataOnceUpdatesData()
    }
    
    @Test func refreshDataStillRefreshesRouteIfNoShuttles() async {
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
                    )
                )
            )
        )
        
        let mockClient = MockApolloClient()
        mockClient.queryMock = mock
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        let viewModel = RouteInfoContentView.ViewModel(apolloNetworkModel: networkModel)
        let arguments = networkArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 0)
    }
    
    @Test func refreshDataOnceSortsShuttlesBySecondsRemaining() async {
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
        
        let mockClient = MockApolloClient()
        mockClient.queryMock = mock
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        let viewModel = RouteInfoContentView.ViewModel(apolloNetworkModel: networkModel)
        let arguments = networkArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.shuttles.count == 3)
        #expect(viewModel.shuttles[0].secondsRemaining == 30)
        #expect(viewModel.shuttles[1].secondsRemaining == 125)
        #expect(viewModel.shuttles[2].secondsRemaining == nil)
    }
}
