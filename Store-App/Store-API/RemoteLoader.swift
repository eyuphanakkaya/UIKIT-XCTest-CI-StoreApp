//
//  RemoteLoader.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 26.02.2026.
//

import Foundation


final public class RemoteLoader<T> {
    private let client: HTTPClient
    private let url: URL
    private let mapper: (Data, HTTPURLResponse) throws -> T
    
    public init(client: HTTPClient, url: URL, closure: @escaping (Data, HTTPURLResponse) throws -> T) {
        self.client = client
        self.url = url
        mapper = closure
    }
    
    public typealias Mapper = (Data, URLResponse) throws -> T
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load() async throws -> T {
        guard let (data, response) = try? await client.get(url) else {
            throw Error.connectivity
        }
        guard let model = try? mapper(data, response) else {
            throw Error.invalidData
        }
        
        return model
    }
}

