//
//  StoreStorageTestsHelpers.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//

import Foundation
import Store_App


func makeEmptyListJson() -> Data {
    "[]".data(using: .utf8)!
}
func anyHttpResponse(statusCode: Int) -> HTTPURLResponse {
    let url = URL(string: "https://example.com")!
    return HTTPURLResponse(url:  url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeInvalidJson() -> Data {
    "invalid json".data(using: .utf8)!
}

func makeProduct(_ id: Int, title: String, price: Double, description: String, category: String, image: String)
-> (model: ProductResponse, json: [String: Any]) {
    let item = ProductResponse(id: id, title: title, price: price, description: description, category: category, image: image, isAdded: false)
    
    let jsonItem = [
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image
    ].compactMapValues{$0}
    
    
    return (item, jsonItem)
}
