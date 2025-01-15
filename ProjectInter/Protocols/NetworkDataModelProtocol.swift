//
//  ViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import SwiftUI

protocol NetworkDataModelProtocol: ObservableObject {
    associatedtype T
    
    func startRefreshingData(arguments: T, sleepDuration: Duration)
    func stopRefreshingData()
    func refreshDataOnce(arguments: T) async
}
