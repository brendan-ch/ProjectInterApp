//
//  UserDefaultsMigrator.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.06.
//

import Foundation

struct UserDefaultsMigrator {
    let standardUserDefaults: UserDefaults
    let sharedUserDefaults: UserDefaults?
    
    // MARK: - Interface
    init(
        standardUserDefaults: UserDefaults = .standard,
        sharedUserDefaults: UserDefaults? = .group
    ) {
        self.standardUserDefaults = standardUserDefaults
        self.sharedUserDefaults = sharedUserDefaults
    }

    func run() {
        migrateToSharedUserDefaults(forKey: UserDefaults.selectedSystemIdKey)
        migrateToSharedUserDefaults(forKey: UserDefaults.initialSystemIdKey, to: UserDefaults.selectedSystemIdKey)
        migrateToSharedUserDefaults(forKey: UserDefaults.setupCompletedKey)
    }
    
    // MARK: - Migrations
    private func migrateToSharedUserDefaults(forKey key: String, to destinationKey: String? = nil) {
        if let value = standardUserDefaults.value(forKey: key) {
            sharedUserDefaults?.setValue(value, forKey: destinationKey ?? key)
        }
        standardUserDefaults.removeObject(forKey: key)
    }
}
