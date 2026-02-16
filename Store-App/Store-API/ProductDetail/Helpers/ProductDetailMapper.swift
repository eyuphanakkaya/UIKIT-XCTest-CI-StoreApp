//
//  ProductDetailMapper.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation

final class ProductDetailMapper {
    func map(data: Data, from response: HTTPURLResponse) throws -> ProductResponse {
        guard response.statusCode == 200, let result = try? JSONDecoder().decode(RemoteProductResponse.self, from: data)  else {
            throw ProductDetailService.ProductDetailError.invalidData
        }

        return result.toDomain()
    }
}
