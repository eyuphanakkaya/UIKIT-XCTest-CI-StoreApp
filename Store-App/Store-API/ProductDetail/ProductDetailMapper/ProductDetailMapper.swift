//
//  ProductDetailMapper.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation

public struct ProductDetailMapper {
    public static func map(data: Data, from response: HTTPURLResponse) throws -> ProductResponse {
        guard response.statusCode == 200  else {
            throw RemoteLoader<ProductResponse>.Error.invalidData
        }

        let decoder = JSONDecoder()
        let productDetailResponse = try decoder.decode(RemoteProductResponse.self, from: data)
        return productDetailResponse.toDomain()
    }
}
