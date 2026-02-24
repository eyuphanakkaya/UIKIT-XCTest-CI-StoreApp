//
//  StoreStorageTestsHelpers.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//

import Foundation
import Store_App


func emptyListResponse() -> (Data, HTTPURLResponse) {
    let emptyListJSON = "[]".data(using: .utf8)!
    return (emptyListJSON, anyHttpResponse(statusCode: 200))
}

func anyHttpResponse(statusCode: Int) -> HTTPURLResponse {
    let url = URL(string: "https://example.com")!
    return HTTPURLResponse(url:  url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func anyValidResponse() -> (Data, HTTPURLResponse) {
    return (Data(), anyHttpResponse(statusCode: 200))
}

func makeInvalidJsonResponse() -> (Data, HTTPURLResponse) {
    let invalidJSON = "invalid json".data(using: .utf8)!
    return (invalidJSON, anyHttpResponse(statusCode: 200))
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
