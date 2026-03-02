//
//  CategoryMapper.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 17.02.2026.
//

import Foundation

public struct CategoryMapper {
    static var magic_num: Int { 200 }
    
    
    public static func map(data: Data, from response: HTTPURLResponse) throws -> [String] {
        guard response.statusCode == magic_num else {
            throw RemoteLoader<[String]>.Error.invalidData
        }
        let decoder = JSONDecoder()
        let categories = try decoder.decode([String].self, from: data)
        return categories
    }
}

