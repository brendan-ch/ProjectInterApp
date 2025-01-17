//
//  RouteInfoContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

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
}

class RouteInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultArguments = RouteInfoNetworkArguments(systemId: "1", stopId: "1", routeId: "1")
    let defaultMock = Mock<ProjectInterTestMocks.Query>(
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
    let secondaryMock = Mock<ProjectInterTestMocks.Query>(
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

    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        let mockClient = MockApolloClient()
        mockClient.mock = defaultMock
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .seconds(1))
        
        try? await Task.sleep(for: .milliseconds(500))
        
        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 2)
    }
    

    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        // TODO: Find a way to generate this type of test quickly
        // Arrange
        let mockClient = MockApolloClient()
        mockClient.mock = defaultMock
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        // Act
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(10))
        
        // Assert
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 2)
        
        let updatedMock = secondaryMock
        mockClient.mock = updatedMock
        
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.routeName == "Grey Route")
        #expect(viewModel.routeNextStopName == "Chapman Grand")
        #expect(viewModel.shuttles.count == 1)
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        // Arrange
        let mockClient = MockApolloClient()
        mockClient.mock = defaultMock
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        viewModel.startRefreshingData(arguments: defaultArguments, sleepDuration: .seconds(1))
        
        try? await Task.sleep(for: .milliseconds(500))
        
        // Act
        viewModel.stopRefreshingData()
        mockClient.mock = secondaryMock
        
        try? await Task.sleep(for: .milliseconds(600))
        
        // Assert
        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 2)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let mock = defaultMock
        let mockClient = MockApolloClient()
        mockClient.mock = mock
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routeName == "Red Route")
        #expect(viewModel.routeNextStopName == "Panther Village")
        #expect(viewModel.shuttles.count == 2)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.mock = nil
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routeName == "")
        #expect(viewModel.routeNextStopName == nil)
        #expect(viewModel.shuttles.count == 0)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let viewModel = RouteInfoContentViewModel()
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routeName == "")
        #expect(viewModel.routeNextStopName == nil)
        #expect(viewModel.shuttles.count == 0)
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
        mockClient.mock = mock
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
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
        mockClient.mock = mock
        
        let viewModel = RouteInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.shuttles.count == 3)
        #expect(viewModel.shuttles[0].secondsRemaining == 30)
        #expect(viewModel.shuttles[1].secondsRemaining == 125)
        #expect(viewModel.shuttles[2].secondsRemaining == nil)
    }
}
