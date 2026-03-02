//
//  ProductDetailServiceTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//

import Foundation
import XCTest
import Store_App


@MainActor
final class ProductDetailMapperTests: XCTestCase {
    
    func test_load_deliverErrorOnNon200HTTPResponse() async {
        let samples = [199,201,300,400,500]

        for code in samples {
            let data = Data()
            let response = anyHttpResponse(statusCode: code)
            guard let result = try? ProductDetailMapper.map(data: data, from: response) else {
                return
            }
            
            XCTFail("Expected receive error but got \(result)")
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        let invalidJSON = makeInvalidJson()
        guard let result = try? ProductDetailMapper.map(data: invalidJSON, from: anyHttpResponse(statusCode: 200)) else {
            return
        }
        
        XCTFail("Expected receive error but got \(result)")
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() async {
        let product1 = makeProduct(1, title: "string", price: 100, description: "string", category: "string", image: "http://example.com")
        let validJSON = makeProductDetailJson(product1.json)
        
        do {
            let result = try ProductDetailMapper.map(data: validJSON, from: anyHttpResponse(statusCode: 200))
            XCTAssertEqual(result, product1.model)
        } catch {
            XCTFail("Expected result but got \(error)")
        }
    }
    
    
    // MARK: - Helpers    
    private func makeProductDetailJson(_ productJson: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: productJson)
    }
    
    private func validProductDetailResponse() -> (Data, HTTPURLResponse) {
        let json = """
        {
            "id": 1,
            "title": "Test Product",
            "price": 10.0,
            "description": "Test Description",
            "category": "Test Category",
            "image": "https://image.com/test.png"
        }
        """.data(using: .utf8)!
        
        return (json, anyHttpResponse(statusCode: 200))
    }
}
