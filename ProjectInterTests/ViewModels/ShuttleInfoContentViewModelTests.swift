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

class ShuttleInfoContentViewModelTests {
    let defaultArguments = ShuttleInfoNetworkArguments(systemId: "1", stopId: "1", shuttleId: "1")
    
    @Test func refreshDataOnceUpdatesShuttleInfo() async {
        let mock = Mock<Query>(
            system: .init(
                shuttle: .init(
                    eta: .init(
                        secondsRemaining: 125
                    ), name: "Shuttle 1"
                )
            )
        )
        
        let mockClient = MockApolloClient()
        mockClient.mock = mock
        
        let viewModel = ShuttleInfoContentViewModel(apolloClient: mockClient)
        let arguments = defaultArguments
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.name == "Shuttle 1")
        #expect(viewModel.etaDisplay == "2 min")
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
    
    @Test func refreshDataOnceDoesNothingIfNoShuttleData() async {
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
