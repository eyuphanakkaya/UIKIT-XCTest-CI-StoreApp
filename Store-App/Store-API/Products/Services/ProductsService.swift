//
//  ProductsService.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation

final public class ProductsService: Loader {
    private let client: HTTPClient
    private let url: URL
    
    
    public enum ProductsServiceError: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    
    public func load() async throws -> [ProductResponse]  {
        guard let (data, response) = try? await client.get(url) else {
            throw ProductsServiceError.connectivity
        }
        
        return try map(data, from: response)
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) throws -> [ProductResponse] {
        do {
            let item = try ProductMapper().map(data: data, from: response)
            return item
        } catch {
            throw ProductsServiceError.invalidData
        }
    }
}
