//
//  RawCoordinates.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.03.
//

import Foundation
import CoreLocation

/// A raw set of coordinates from the server, which can be converted into
/// other types of coordinates such as `CLLocationCoordinate2D`.
struct RawCoordinates: Equatable {
    var latitude: Double
    var longitude: Double
    
    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
