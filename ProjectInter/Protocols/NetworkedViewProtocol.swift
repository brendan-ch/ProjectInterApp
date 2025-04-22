//
//  NetworkedViewProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

protocol NetworkeDataViewProtocol: View {
    associatedtype NetworkArguments
    associatedtype ViewModelType: NetworkDataModelProtocol where ViewModelType.T == NetworkArguments
    
    var globalDataModel: GlobalIdSelectionModel { get set }
    
    var viewModel: ViewModelType { get set }
    
    var networkArguments: NetworkArguments? { get }
    
    func restartDataUpdates()
}

extension NetworkeDataViewProtocol {
    func restartDataUpdates() {
        if let apolloClient = globalDataModel.apolloClient {
            viewModel.apolloClient = apolloClient
        }
        
        if let networkArguments = networkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: networkArguments)
        }
    }
}
