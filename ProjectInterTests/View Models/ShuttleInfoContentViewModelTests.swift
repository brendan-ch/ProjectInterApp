//
//  ShuttleInfoContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks
import ProjectInterOperations

class ShuttleInfoContentViewModelMockData {
    static let defaultMock = Mock<Query>(
        secondsThresholdForNotification: 239,
        system: .init(
            shuttle: .init(
                etas: [
                    .init(
                        secondsRemaining: 125,
                        stop: .init(
                            id: "1",
                            name: "Stop 1"
                        )
                    ),
                    .init(
                        secondsRemaining: 20,
                        stop: .init(
                            id: "2",
                            name: "Stop 2"
                        )
                    ),
                ],
                name: "Shuttle 1"
            )
        )
    )
    
    static let secondaryMock = Mock<Query>(
        secondsThresholdForNotification: nil,
        system: .init(
            shuttle: .init(
                etas: [
                    .init(
                        secondsRemaining: 306,
                        stop: .init(
                            id: "1",
                            name: "Stop 1"
                        )
                    ),
                    .init(
                        secondsRemaining: 205,
                        stop: .init(
                            id: "2",
                            name: "Stop 2"
                        )
                    ),
                ],
                name: "Shuttle 2"
            )
        )
    )

}

class ShuttleInfoEtaListItemTests {
    @Test func apolloInitializerInitializesData() async {
        let data = await GetShuttleInfoDataQuery.Data.from(ShuttleInfoContentViewModelMockData.defaultMock)
        let etas = data.system!.shuttle!.etas!
        
        let constructedEtas = etas.map(ShuttleInfoEtaListItem.init)
        for i in 0..<constructedEtas.count {
            let secondsRemaining: ETASeconds = ETASeconds(etas[i].secondsRemaining)
            #expect(secondsRemaining == constructedEtas[i].secondsRemaining)
            #expect(etas[i].stop?.name == constructedEtas[i].stopName)
            #expect(etas[i].stop?.id == constructedEtas[i].stopId)
        }
    }
}

class ShuttleInfoContentViewModelTests {
    let defaultMock = ShuttleInfoContentViewModelMockData.defaultMock

    @Test("injectUpdate maps shuttle info, sorts ETAs, and sets notification state") func injectUpdateMapsShuttleInfo() async {
        let viewModel = ShuttleInfoContentView.ViewModel()
        viewModel.stopId = "1"
        let data = await GetShuttleInfoDataQuery.Data.from(defaultMock)

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.name == "Shuttle 1")
        #expect(viewModel.etaDisplay == "2 min to Stop 1")

        // Check sorting of items
        #expect(viewModel.etaListItems.count == 2)
        #expect(viewModel.etaListItems[0].secondsRemaining == 20)
        #expect(viewModel.etaListItems[1].secondsRemaining == 125)

        #expect(viewModel.isNotificationScheduled)
        #expect(viewModel.secondsThresholdForNotification == 239)

        #expect(viewModel.notificationButtonText == "Cancel 3-minute notification")
    }

    @Test func injectUpdateUpdatesEtaCorrectlyIfUnderOneMin() async {
        let viewModel = ShuttleInfoContentView.ViewModel()
        viewModel.stopId = "1"
        let data = await GetShuttleInfoDataQuery.Data.from(
            Mock<Query>(
                system: .init(
                    shuttle: .init(
                        etas: [
                            .init(
                                secondsRemaining: 20,
                                stop: .init(
                                    id: "1",
                                    name: "Stop 1"
                                )
                            )
                        ],
                        name: "Shuttle 1"
                    )
                )
            )
        )

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.etaDisplay == "Under 1 minute to Stop 1")
    }

    @Test func availableNotificationOptionsReturnsAllOptionsWhenNoETA() {
        let viewModel = ShuttleInfoContentView.ViewModel()
        #expect(viewModel.availableNotificationOptions == [2, 5, 10])
    }

    @Test func availableNotificationOptionsFiltersBasedOnETA() async {
        let viewModel = ShuttleInfoContentView.ViewModel()
        viewModel.stopId = "1"
        // Test with 8 minutes (480 seconds) ETA - should show 2 and 5 minute options
        let data = await GetShuttleInfoDataQuery.Data.from(
            Mock<Query>(
                system: .init(
                    shuttle: .init(
                        etas: [
                            .init(
                                secondsRemaining: 480, // 8 minutes
                                stop: .init(
                                    id: "1",
                                    name: "Stop 1"
                                )
                            )
                        ],
                        name: "Shuttle 1"
                    )
                )
            )
        )
        await viewModel.injectUpdate(.success(data))
        #expect(viewModel.availableNotificationOptions == [2, 5])
    }
}

class GenerateNotificationInputTests {
    @Test("generateNotificationInput includes the seconds threshold when provided") func includesThreshold() {
        let arguments = ShuttleInfoContentView.NotificationNetworkArguments(
            deviceId: "1",
            shuttleId: "1",
            stopId: "1",
            secondsThreshold: 300
        )

        let input = ShuttleInfoContentView.generateNotificationInput(arguments)

        #expect(input.deviceId == "1")
        #expect(input.shuttleId == "1")
        #expect(input.stopId == "1")
        #expect(input.secondsThreshold == 300)
    }

    @Test("generateNotificationInput omits the seconds threshold when nil") func omitsThreshold() {
        let arguments = ShuttleInfoContentView.NotificationNetworkArguments(
            deviceId: "1",
            shuttleId: "1",
            stopId: "1",
            secondsThreshold: nil
        )

        let input = ShuttleInfoContentView.generateNotificationInput(arguments)

        #expect(input.secondsThreshold == nil)
    }
}
