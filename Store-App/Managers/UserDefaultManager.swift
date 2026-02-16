//
//  UserDefaultManager.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 13.02.2026.
//

import Foundation

final class UserDefaultManager: StoreStorage {
    private let defaults: UserDefaults
    private let key = "userDefaultKey"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func insert(_ id: String) {
        var current = defaults.stringArray(forKey: key) ?? []
        current.append(id)
        defaults.set(current, forKey: key)
    }
    
    func retrieve() -> [String] {
        defaults.stringArray(forKey: key) ?? []
    }
    
    func delete(_ id: String) {
        var current = defaults.stringArray(forKey: key) ?? []
        current.removeAll { $0 == id }
        defaults.set(current, forKey: key)
    }
}
