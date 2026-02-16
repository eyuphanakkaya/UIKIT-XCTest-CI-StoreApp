//
//  StoreStorage.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 13.02.2026.
//

import Foundation

protocol StoreStorage {    
    func insert(_ id: String)
    func retrieve() -> [String]
    func delete(_ id: String) 
}
