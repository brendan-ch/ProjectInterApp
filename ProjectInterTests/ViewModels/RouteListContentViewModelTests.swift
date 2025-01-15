//
//  RouteListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.09.
//

import Testing
@testable import ProjectInter
import ProjectInterTestMocks
import ApolloTestSupport

class RouteListContentViewRouteTests {
    func generateRouteObject() -> RouteListContentViewRoute {
        return RouteListContentViewRoute(
            id: "1",
            name: "Chapman Court",
            colorHex: "#000000",
            nextStopName: "Panther Village"
        )
    }
    
    @Test func etaDisplaysCorrectlyWithEtas() async throws {
        var route = generateRouteObject()
        route.addEta(25)
        route.addEta(125)
        route.addEta(332)
        
        let expectedString = "<1, 2, 5 min"
        #expect(route.etaDisplayString == expectedString)
    }
    
    @Test func etaDisplaysCorrectlyWithNoEtas() async throws {
        let route = generateRouteObject()
        
        let expectedString = "N/A"
        #expect(route.etaDisplayString == expectedString)
    }
    
    @Test func addEtaSortsEtasInAscendingOrder() async throws {
        var route = generateRouteObject()
        route.addEta(125)
        route.addEta(25)
        #expect(route.etasInSeconds == [25, 125])
    }
    
    @Test func clearEtasClearsEtas() async throws {
        var route = generateRouteObject()
        route.addEta(125)
        route.addEta(25)
        route.clearEtas()
        #expect(route.etasInSeconds.isEmpty)
    }
}

class RouteListContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultArguments = RouteListNetworkArguments(systemId: "1", stopId: "1")
    let defaultMock = Mock<ProjectInterTestMocks.Query>(
        system: Mock<ProjectInterTestMocks.System>(
            stop: Mock<ProjectInterTestMocks.Stop>(
                name: "Chapman Court",
                orderedStops: [
                    Mock<ProjectInterTestMocks.OrderedStop>(
                        nextStop: Mock<ProjectInterTestMocks.OrderedStop>(
                            stop: Mock<ProjectInterTestMocks.Stop>(
                                name: "Panther Village"
                            )
                        ), route: Mock<ProjectInterTestMocks.Route>(
                            color: "#000000", id: "1",
                            name: "Black Route",
                            shuttles: [
                                Mock<ProjectInterTestMocks.Shuttle>(
                                    eta: Mock<ProjectInterTestMocks.ETA>(
                                        secondsRemaining: 35
                                    )
                                ),
                                Mock<ProjectInterTestMocks.Shuttle>(
                                    eta: Mock<ProjectInterTestMocks.ETA>(
                                        secondsRemaining: 125
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        )
    )
    
    let secondaryMock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                stop: Mock<ProjectInterTestMocks.Stop>(
                    name: "Chapman Court",
                    orderedStops: [
                        Mock<ProjectInterTestMocks.OrderedStop>(
                            nextStop: Mock<ProjectInterTestMocks.OrderedStop>(
                                stop: Mock<ProjectInterTestMocks.Stop>(
                                    name: "Panther Village"
                                )
                            ), route: Mock<ProjectInterTestMocks.Route>(
                                color: "#000000", id: "1",
                                name: "Black Route",
                                shuttles: [
                                    Mock<ProjectInterTestMocks.Shuttle>(
                                        eta: Mock<ProjectInterTestMocks.ETA>(
                                            secondsRemaining: 125
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        )

    
    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        // Arrange
        let mockClient = MockApolloClient()
        mockClient.mock = defaultMock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        // Act
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(10))
        
        // Assert
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
        
        // Arrange
        mockClient.mock = secondaryMock
        
        // Assert
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.routes[0].etasInSeconds.count == 1)
    }

    @Test func stopRefreshingDataStopsDataRefresh() async {
        // Arrange
        let mockClient = MockApolloClient()
        mockClient.mock = defaultMock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        viewModel.startRefreshingData(arguments: defaultArguments, sleepDuration: .milliseconds(10))
        
        // Act
        try? await Task.sleep(for: .milliseconds(50))
        viewModel.stopRefreshingData()
        mockClient.mock = secondaryMock
        
        // Assert
        try? await Task.sleep(for: .milliseconds(50))
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let mock = defaultMock
        let mockClient = MockApolloClient()
        mockClient.mock = mock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.mock = nil
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.isEmpty)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let viewModel = RouteListContentViewModel()
        let arguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.isEmpty)
    }
}
