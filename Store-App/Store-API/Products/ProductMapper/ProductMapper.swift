//
//  ProductMapper.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation

public struct ProductMapper {
    public static func map(data: Data,from response: HTTPURLResponse) throws -> [ProductResponse] {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode([RemoteProductResponse].self, from: data) else{
            throw RemoteLoader<[ProductResponse]>.Error.invalidData
        }
        
        return root.map{$0.toDomain()}
        
    }
}
