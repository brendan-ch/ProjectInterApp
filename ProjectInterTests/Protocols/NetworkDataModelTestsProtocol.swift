//
//  NetworkDataModelProtocolTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.14.
//

// TODO: Implement this protocol in all view model tests

protocol NetworkDataModelTestsProtocol {
    func startRefreshingDataRefreshesDataOnFirstCall() async
    func startRefreshingDataRefreshesDataMultipleTimes() async
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async
    func refreshDataOnceUpdatesData() async
    func refreshDataOnceDoesNothingIfNoData() async
    func refreshDataOnceDoesNothingIfNoApolloClient() async
}
