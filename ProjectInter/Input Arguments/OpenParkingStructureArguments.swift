//
//  OpenParkingStructureArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

/// Arguments needed for the app to open a parking structure, say,
/// from a URL or notification.
struct OpenParkingStructureArguments: URLConstructable, Equatable {
    let parkingStructureId: String
    let systemId: String
}

extension OpenParkingStructureArguments {
    static var expectedUrlPath: String { "/openParkingStructure" }
}
