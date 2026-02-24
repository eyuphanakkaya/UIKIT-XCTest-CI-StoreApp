//
//  StoreStorageTestsHelpers.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//

import Foundation


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
