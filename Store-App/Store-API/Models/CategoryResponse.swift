//
//  CategoryResponse.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 26.01.2026.
//

import Foundation

struct CategoryResponse: Decodable {
    let id: Int
    let name: String
    let image: String
    let slug: String
}
