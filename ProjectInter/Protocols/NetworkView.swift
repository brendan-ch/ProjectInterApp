//
//  NetworkedViewProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

protocol NetworkView: View {
    associatedtype NetworkArguments
    associatedtype ViewModelType: NetworkDataModelProtocol where ViewModelType.NetworkArguments == NetworkArguments
    
    var globalSystemsModel: GlobalSystemsModel { get }
    
    var viewModel: ViewModelType { get }
    
    var networkArguments: NetworkArguments? { get }
    
    func restartDataUpdates()
    func stopDataUpdates()
}

extension NetworkView {
    func restartDataUpdates() {
        if let apolloClient = globalSystemsModel.apolloClient {
            viewModel.apolloClient = apolloClient
        }
        
        if let networkArguments = networkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: networkArguments)
        }
    }
    
    func stopDataUpdates() {
        viewModel.stopRefreshingData()
    }
}
