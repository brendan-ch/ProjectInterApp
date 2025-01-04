//
//  RawCoordinates.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.03.
//

import Foundation

// TODO: apply this model to objects in MapViewModel

/// A raw set of coordinates from the server, which can be converted into
/// other types of coordinates such as `CLLocationCoordinate2D`.
struct RawCoordinates: Equatable {
    var latitude: Double
    var longitude: Double
}
