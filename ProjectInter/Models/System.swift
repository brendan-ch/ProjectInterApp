//
//  System.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import Foundation

// Models to be consumed directly by the user interface,
// separated from API models.
// Goal is to simplify preview data and unit testing.

struct System: Equatable, Identifiable {
    var name: String
    var id: String
}
