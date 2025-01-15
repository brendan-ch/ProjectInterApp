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

class ShuttleInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultArguments = ShuttleInfoNetworkArguments(systemId: "1", stopId: "1", shuttleId: "1")
    let defaultMock = Mock<Query>(
        system: .init(
            shuttle: .init(
                eta: .init(
                    secondsRemaining: 125
                ), name: "Shuttle 1"
            )
        )
    )
    
    func startRefreshingDataRefreshesDataOnFirstCall() async {
        
    }
    
    func startRefreshingDataRefreshesDataMultipleTimes() async {
        
    }
    
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        
    }
    
    func assertViewModelDataForDefaultMock(viewModel: ShuttleInfoContentViewModel) {
        #expect(viewModel.name == "Shuttle 1")
        #expect(viewModel.etaDisplay == "2 min")
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ShuttleInfoContentViewModel) {
        #expect(viewModel.name == "Shuttle 2")
        #expect(viewModel.etaDisplay == "5 min")
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let mock = defaultMock
        
        let mockClient = MockApolloClient()
        mockClient.mock = mock
        
        let viewModel = ShuttleInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceUpdatesEtaCorrectlyIfUnderOneMin() async {
        let mock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    eta: .init(
                        secondsRemaining: 20
                    ), name: "Shuttle 1"
                )
            )
        )
        
        let mockClient = MockApolloClient()
        mockClient.mock = mock
        
        let viewModel = ShuttleInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.etaDisplay == "Less than 1 min")
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.mock = nil
        
        let viewModel = ShuttleInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "")
        #expect(viewModel.etaDisplay == "")
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let viewModel = ShuttleInfoContentViewModel()
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "")
        #expect(viewModel.etaDisplay == "")
    }
}
