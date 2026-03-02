//
//  ProductResponse.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation

public struct ProductResponse: Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
    var isAdded: Bool
    
    var convertToIdString : String {
        return "\(id)"
    }
    
    public init(id: Int, title: String, price: Double, description: String, category: String, image: String, isAdded: Bool) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.category = category
        self.image = image
        self.isAdded = isAdded
    }
}

extension ProductResponse {
    func priceFormatted() -> String {
        return "\(price) $"
    }
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
    func toDomain() -> ProductResponse {
        return ProductResponse(id: id, title: title, price: price, description: description, category: category, image: image, isAdded: false)
    }
}
