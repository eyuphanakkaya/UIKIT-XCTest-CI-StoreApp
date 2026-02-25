//
//  Loader.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//

import Foundation

public protocol Loader {
    associatedtype Output
    
    func load() async throws -> Output
}
