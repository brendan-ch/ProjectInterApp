//
//  BundleClass.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation

public class BundleClass {
    public var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    public init() {}
}
