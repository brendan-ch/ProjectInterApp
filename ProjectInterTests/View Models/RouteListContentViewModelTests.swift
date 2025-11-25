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
import ProjectInterShared

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
    
    static let tertiaryMock = Mock<ProjectInterTestMocks.Query>(
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
                            color: "#FF0000", id: "1",
                            name: "Red Route",
                            shuttles: [
                                Mock<ProjectInterTestMocks.Shuttle>(
                                )
                            ]
                        )
                    ),
                    Mock<ProjectInterTestMocks.OrderedStop>(
                        nextStop: Mock<ProjectInterTestMocks.OrderedStop>(
                            stop: Mock<ProjectInterTestMocks.Stop>(
                                name: "Chapman Grand"
                            )
                        ), route: Mock<ProjectInterTestMocks.Route>(
                            color: "#000000", id: "2",
                            name: "Black Route",
                            shuttles: [
                                Mock<ProjectInterTestMocks.Shuttle>(
                                )
                            ]
                        )
                    )
                ]
            )
        )
    )
    
    static let fourthMock = Mock<ProjectInterTestMocks.Query>(
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
                            color: "#FF0000", id: "1",
                            name: "Red Route",
                            shuttles: [
                                Mock<ProjectInterTestMocks.Shuttle>(
                                )
                            ]
                        )
                    ),
                    Mock<ProjectInterTestMocks.OrderedStop>(
                        nextStop: Mock<ProjectInterTestMocks.OrderedStop>(
                            stop: Mock<ProjectInterTestMocks.Stop>(
                                name: "Chapman Grand"
                            )
                        ), route: Mock<ProjectInterTestMocks.Route>(
                            color: "#000000", id: "2",
                            name: "Black Route",
                            shuttles: [
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
            nextStopName: "Panther Village",
            etasInSeconds: [],
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
        
        let expectedString = ""
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
                    #expect(ETASeconds(shuttles[j].eta!.secondsRemaining) == constructedRoutes[i].etasInSeconds[j])
                }
            }
            
        }
    }
}

class RouteListContentViewModelTests: NetworkDataModelTestsProtocol {
    let networkArguments = RouteListNetworkArguments(systemId: "1", stopId: "1")
    let defaultMock = RouteListContentViewModelMockData.defaultMock
    let secondaryMock = RouteListContentViewModelMockData.secondaryMock
    let tertiaryMock = RouteListContentViewModelMockData.tertiaryMock
    let fourthMock = RouteListContentViewModelMockData.fourthMock
    
    func assertViewModelDataForDefaultMock(viewModel: RouteListContentView.ViewModel) {
        #expect(viewModel.activeRoutes.count == 1)
        #expect(viewModel.activeRoutes[0].etasInSeconds.count == 2)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ProjectInter.RouteListContentView.ViewModel) {
        #expect(viewModel.activeRoutes[0].etasInSeconds.count == 1)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: RouteListContentView.ViewModel) {
        #expect(viewModel.activeRoutes.isEmpty)
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
        await autoTest_refreshDataOnceDoesNothingIfNoApolloClient()
    }
    
    @Test func loadedRoutesAreSorted() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = tertiaryMock
        
        let mockNetworkModel = ApolloNetworkModel(client: mockClient)
        
        let viewModel = RouteListContentView.ViewModel(apolloNetworkModel: mockNetworkModel)
        
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.activeRoutes[0].name == "Black Route")
        #expect(viewModel.activeRoutes[1].name == "Red Route")
    }
    
    @Test func routesWithoutShuttlesAreAddedToInactiveRoutes() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = fourthMock
        
        let mockNetworkModel = ApolloNetworkModel(client: mockClient)
        
        let viewModel = RouteListContentView.ViewModel(apolloNetworkModel: mockNetworkModel)
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.inactiveRoutes[0].name == "Black Route")
        #expect(viewModel.activeRoutes[0].name == "Red Route")
    }
}
