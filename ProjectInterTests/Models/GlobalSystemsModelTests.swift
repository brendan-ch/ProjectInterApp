//
//  GlobalDataStateTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Foundation
import MapKit
import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks
import ProjectInterShared

class GlobalSystemsModelTests {
    @Test func testRefreshSystemData() async throws {
        let mockClient = MockApolloClient()
        
        let mock = Mock<ProjectInterTestMocks.Query>(
            systems: [
                Mock<ProjectInterTestMocks.System>(
                    id: "1",
                    name: "Chapman University"
                ),
                Mock<ProjectInterTestMocks.System>(
                    id: "2",
                    name: "City of Monterey Park"
                ),
            ]
        )
        mockClient.queryMock = mock
        
        let networkModel = ApolloNetworkModel(client: mockClient)

        let globalDataState = GlobalSystemsModel(apolloNetworkModel: networkModel)
        await globalDataState.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
        
        #expect(globalDataState.systems.count == 2)
    }
    
    @Test func testRefreshSystemDataWithInvalidData() async throws {
        let mockClient = MockApolloClient()
        mockClient.queryMock = nil
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        let globalDataState = GlobalSystemsModel(apolloNetworkModel: networkModel)
        await globalDataState.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())
        
        #expect(globalDataState.systems.count == 0)
    }
    
    @Test func testUpdateSystemIdUpdatesSelectedSystemAndUserDefaults() async {
        let mockUserDefaults = MockUserDefaults()
        
        let state = GlobalSystemsModel(apolloNetworkModel: nil, userDefaults: mockUserDefaults)
        state.systems = [
            .init(name: "Chapman University", id: "1"),
            .init(name: "CSULB", id: "2")
        ]
        
        state.selectSystemId("2")
        
        #expect(state.selectedSystem?.name == "CSULB")
        #expect(mockUserDefaults.lastKeySetTo == UserDefaults.selectedSystemIdKey)
        #expect(mockUserDefaults.lastValueSetTo as? String == "2")
    }
    
    // TODO: Add test for UserDefaults and state update

    @Test func testRefreshSystemDataIncludesInitialRegion() async throws {
        let mockClient = MockApolloClient()

        let mock = Mock<ProjectInterTestMocks.Query>(
            systems: [
                Mock<ProjectInterTestMocks.System>(
                    id: "1",
                    initialRegion: Mock<ProjectInterTestMocks.Region>(
                        bottomRight: Mock<ProjectInterTestMocks.Coordinates>(
                            latitude: 33.785,
                            longitude: -117.845
                        ),
                        topLeft: Mock<ProjectInterTestMocks.Coordinates>(
                            latitude: 33.800,
                            longitude: -117.900
                        )
                    ),
                    name: "Chapman University"
                ),
            ]
        )
        mockClient.queryMock = mock

        let networkModel = ApolloNetworkModel(client: mockClient)
        let globalDataState = GlobalSystemsModel(apolloNetworkModel: networkModel)
        await globalDataState.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())

        let region = globalDataState.systems.first?.initialRegion
        #expect(region != nil)
        #expect(region?.topLeft.latitude == 33.800)
        #expect(region?.topLeft.longitude == -117.900)
        #expect(region?.bottomRight.latitude == 33.785)
        #expect(region?.bottomRight.longitude == -117.845)
    }

    @Test func testRefreshSystemDataHandlesNilInitialRegion() async throws {
        let mockClient = MockApolloClient()

        let mock = Mock<ProjectInterTestMocks.Query>(
            systems: [
                Mock<ProjectInterTestMocks.System>(
                    id: "1",
                    name: "Chapman University"
                ),
            ]
        )
        mockClient.queryMock = mock

        let networkModel = ApolloNetworkModel(client: mockClient)
        let globalDataState = GlobalSystemsModel(apolloNetworkModel: networkModel)
        await globalDataState.refreshDataOnce(arguments: GlobalDataModelNetworkArguments())

        #expect(globalDataState.systems.count == 1)
        #expect(globalDataState.systems.first?.initialRegion == nil)
    }

    @Test func testInitialRegionConvertsToMKCoordinateRegion() {
        let initialRegion = InitialRegion(
            topLeft: RawCoordinates(latitude: 33.800, longitude: -117.900),
            bottomRight: RawCoordinates(latitude: 33.780, longitude: -117.840)
        )

        let mkRegion = initialRegion.asMKCoordinateRegion

        #expect(mkRegion.center.latitude == (33.800 + 33.780) / 2)
        #expect(mkRegion.center.longitude == (-117.900 + -117.840) / 2)
        #expect(mkRegion.span.latitudeDelta == abs(33.800 - 33.780))
        #expect(mkRegion.span.longitudeDelta == abs(-117.900 - (-117.840)))
    }
}
