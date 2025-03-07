//
//  CLLocationCoordinate2D.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.06.
//

import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
