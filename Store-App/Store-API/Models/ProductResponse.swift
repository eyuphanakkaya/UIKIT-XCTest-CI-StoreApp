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
    let category: String
    let image: String
}

struct RemoteProductResponse: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
}
extension RemoteProductResponse {
    func toDomain() -> [ProductResponse] {
        return [ProductResponse(id: id, title: title, price: price, description: description, category: category, image: image)]
    }
}
