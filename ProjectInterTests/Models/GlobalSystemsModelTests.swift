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
import ProjectInterOperations
import ProjectInterShared

class GlobalSystemsModelTests {
    let systemsMock = Mock<ProjectInterTestMocks.Query>(
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

    let initialRegionMock = Mock<ProjectInterTestMocks.Query>(
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

    @Test("injectUpdate maps the systems list") func injectUpdateMapsSystems() async {
        let model = GlobalSystemsModel()
        let data = await GetAllSystemsQuery.Data.from(systemsMock)

        await model.injectUpdate(.success(data))

        #expect(model.systems.count == 2)
    }

    @Test("injectUpdate maps the initial region") func injectUpdateMapsInitialRegion() async {
        let model = GlobalSystemsModel()
        let data = await GetAllSystemsQuery.Data.from(initialRegionMock)

        await model.injectUpdate(.success(data))

        let region = model.systems.first?.initialRegion
        #expect(region != nil)
        #expect(region?.topLeft.latitude == 33.800)
        #expect(region?.topLeft.longitude == -117.900)
        #expect(region?.bottomRight.latitude == 33.785)
        #expect(region?.bottomRight.longitude == -117.845)
    }

    @Test("injectUpdate handles a nil initial region") func injectUpdateHandlesNilInitialRegion() async {
        let model = GlobalSystemsModel()
        let data = await GetAllSystemsQuery.Data.from(systemsMock)

        await model.injectUpdate(.success(data))

        #expect(model.systems.count == 2)
        #expect(model.systems.allSatisfy({ $0.initialRegion == nil }))
    }

    @Test func testUpdateSystemIdUpdatesSelectedSystemAndUserDefaults() async {
        let mockUserDefaults = MockUserDefaults()

        let state = GlobalSystemsModel(userDefaults: mockUserDefaults)
        state.systems = [
            .init(name: "Chapman University", id: "1"),
            .init(name: "CSULB", id: "2")
        ]

        state.selectSystemId("2")

        #expect(state.selectedSystem?.name == "CSULB")
        #expect(mockUserDefaults.lastKeySetTo == UserDefaults.selectedSystemIdKey)
        #expect(mockUserDefaults.lastValueSetTo as? String == "2")
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
