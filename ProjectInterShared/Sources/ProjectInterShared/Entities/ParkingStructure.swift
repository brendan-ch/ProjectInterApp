//
//  ParkingStructure.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.07.
//

import Foundation

public struct ParkingStructure: Identifiable {
    public let id: String
    public let name: String
    public let capacity: Int
    public let spotsAvailable: Int
    
    public var currentCount: Int {
        capacity - spotsAvailable
    }
    
    public init(id: String, name: String, capacity: Int, spotsAvailable: Int) {
        self.id = id
        self.name = name
        self.capacity = capacity
        self.spotsAvailable = spotsAvailable
    }
}

public extension ParkingStructure {
    static let mock: ParkingStructure = .init(
        id: "1",
        name: "Parking Structure A",
        capacity: 100,
        spotsAvailable: 40
    )
}

