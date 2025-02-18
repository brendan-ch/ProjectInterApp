//
//  RouteListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.09.
//

import Testing
@testable import ProjectInter
import ProjectInterTestMocks
import ProjectInterOperations
import ApolloTestSupport

class RouteListContentViewModelMockData {
    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
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
    
    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
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
}

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
    
    @Test func apolloInitializerInitializesData() {
        let data = GetRouteListDataQuery.Data.from(RouteListContentViewModelMockData.defaultMock)
        let routes = data.system!.stop!.orderedStops!.map { $0.route! }
        
        let constructedRoutes = routes.map(RouteListContentViewRoute.init)
        for i in 0..<constructedRoutes.count {
            #expect(routes[i].color == constructedRoutes[i].colorHex)
            #expect(routes[i].id == constructedRoutes[i].id)
            #expect(routes[i].name == constructedRoutes[i].name)
            
            if let shuttles = routes[i].shuttles {
                for j in 0..<shuttles.count {
                    #expect(shuttles[j].eta?.secondsRemaining == constructedRoutes[i].etasInSeconds[j])
                }
            }
            
        }
    }
}

class RouteListContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultArguments = RouteListNetworkArguments(systemId: "1", stopId: "1")
    let defaultMock = RouteListContentViewModelMockData.defaultMock
    let secondaryMock = RouteListContentViewModelMockData.secondaryMock

    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .seconds(1))
        
        try? await Task.sleep(for: .milliseconds(500))
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
    }
    

    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        // Arrange
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        // Act
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(100))
        
        // Assert
        try? await Task.sleep(for: .milliseconds(500))
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
        
        // Arrange
        mockClient.queryMock = secondaryMock
        
        // Assert
        try? await Task.sleep(for: .milliseconds(600))
        
        #expect(viewModel.routes[0].etasInSeconds.count == 1)
    }

    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        // Arrange
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        viewModel.startRefreshingData(arguments: defaultArguments, sleepDuration: .milliseconds(100))
        
        // Act
        try? await Task.sleep(for: .milliseconds(500))
        viewModel.stopRefreshingData()
        mockClient.queryMock = secondaryMock
        
        // Assert
        // Wait for the task to expire
        try? await Task.sleep(for: .milliseconds(600))
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let mock = defaultMock
        let mockClient = MockApolloClient()
        mockClient.queryMock = mock
        
        let viewModel = RouteListContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.routes[0].etasInSeconds.count == 2)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = nil
        
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
