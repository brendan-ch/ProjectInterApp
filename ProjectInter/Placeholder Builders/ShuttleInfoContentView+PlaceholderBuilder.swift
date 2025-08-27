//
//  ShuttleInfoContentViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import Foundation

extension ShuttleInfoContentView {
    class PlaceholderBuilder: PlaceholderBuilderProtocol {
        typealias PlaceholderType = ViewModel
        
        func build() -> ViewModel {
            let model = ViewModel()
            
            Task {
                DispatchQueue.main.sync {
                    model.dataInitState = .initializing
                }
                try? await Task.sleep(for: .seconds(2))
                
                DispatchQueue.main.sync {
                    model.dataInitState = .succeeded
                    model.name = "Red Shuttle 17"
                    model.nameOfStop = "Chapman Court"
                    model.etaSecondsRemaining = 20
                    
                    model.etaListItems = [
                        .init(stopName: "Chapman Court", secondsRemaining: 20, stopId: "0"),
                        .init(stopName: "Schmid Gate", secondsRemaining: 125, stopId: "1"),
                        .init(stopName: "Panther Village", secondsRemaining: 300, stopId: "2"),
                        .init(stopName: "Chapman Grand", secondsRemaining: 1430, stopId: "3")
                    ]
                }
            }
            
            return model
        }
    }
}