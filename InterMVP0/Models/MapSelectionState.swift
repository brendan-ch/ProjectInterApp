//
//  MapSelectionState.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.18.
//

import SwiftUI

class MapSelectionState: ObservableObject {
    @Published var selectedRoute: MockRoute?
    @Published var selectedShuttle: Shuttle?
}
