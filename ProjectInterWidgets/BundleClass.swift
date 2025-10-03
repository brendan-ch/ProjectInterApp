//
//  BundleClass.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation

class BundleClass {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
}
