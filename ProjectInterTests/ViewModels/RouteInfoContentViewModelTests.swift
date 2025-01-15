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

class RouteInfoContentViewModelTests {
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
                            secondsRemaining: 30
                        ),
                        id: "1",
                        name: "Shuttle 1"
                    ),
                    .init(
                        eta: .init(
                            secondsRemaining: 125
                        ),
                        id: "2",
                        name: "Shuttle 2"
                    )
                ]
            )
        )
    )

    
    @Test func startRefreshingDataRefreshesDataOverTime() async {
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
        
        let updatedMock = Mock<ProjectInterTestMocks.Query>(
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
        mockClient.mock = updatedMock
        
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.routeName == "Grey Route")
        #expect(viewModel.routeNextStopName == "Chapman Grand")
        #expect(viewModel.shuttles.count == 1)
    }
    
    @Test func stopRefreshingDataStopsDataRefresh() async {
        
    }
    
    @Test func refreshDataOnceRefreshesData() async {
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
}
