//
//  ProductResponse.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation

struct ProductResponse {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: CategoryResponse
    let images: [String]
}

struct RemoteProductResponse: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: CategoryResponse
    let images: [String]
    
}
extension RemoteProductResponse {
    func toDomain() -> ProductResponse {
        return ProductResponse(id: id, title: title, price: price, description: description, category: category, images: images)
    }
}
