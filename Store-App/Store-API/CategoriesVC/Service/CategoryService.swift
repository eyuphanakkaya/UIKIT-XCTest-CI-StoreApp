//
//  CategoryService.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 17.02.2026.
//

import Foundation

final public class CategoryService {
    private let client: HTTPClient
    private let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public enum CategoryServiceError: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load() async throws -> [String] {
        let (data, response) = try await client.get(url)
        return try map(data, from: response)
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) throws -> [String] {
        do {
            let item = try  CategoryMapper().map(data: data, from: response)
            return item
        } catch {
            throw CategoryServiceError.invalidData
        }
    }

}
