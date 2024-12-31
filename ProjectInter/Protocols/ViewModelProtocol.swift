//
//  ViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import SwiftUI

protocol ViewModelProtocol: ObservableObject {
    associatedtype T
    
    func refreshData(arguments: T)
}
