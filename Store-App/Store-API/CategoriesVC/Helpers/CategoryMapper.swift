//
//  CategoryMapper.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 17.02.2026.
//

import Foundation

struct CategoryMapper {
    public func map(data: Data, from response: HTTPURLResponse) throws -> [String] {
        guard response.statusCode == 200 else {
            throw CategoryService.CategoryServiceError.invalidData
        }
        let decoder = JSONDecoder()
        let categories = try decoder.decode([String].self, from: data)
        return categories
    }
}

