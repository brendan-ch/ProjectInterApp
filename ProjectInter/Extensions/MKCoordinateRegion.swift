//
//  MKCoordinateRegion.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import MapKit

extension MKCoordinateRegion: @retroactive Equatable {
    static let anaheim = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.79787, longitude: -117.8937), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta &&
        lhs.center == rhs.center
    }
}
