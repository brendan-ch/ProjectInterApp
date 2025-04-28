//
//  Loggers.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.28.
//


import Foundation
import os

class Loggers {
    let networkingLogger = Logger.init(subsystem: "dev.bchen.Inter", category: "network")
    let systemEventsLogger = Logger.init(subsystem: "dev.bchen.Inter", category: "systemEvents")
    let globalStateEventsLogger = Logger.init(subsystem: "dev.bchen.inter", category: "globalStateEvents")
    
    static let shared = Loggers()
    
    private init() {}
}
