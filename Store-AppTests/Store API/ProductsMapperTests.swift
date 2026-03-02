//
//  ProductsServiceTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 20.02.2026.
//

import XCTest
import Store_App

@MainActor
final class ProductsMapperTests: XCTestCase {
    
    func test_load_deliversErrorOnNon200HTTPResponse() async {
        let samples = [199,201,300,400,500]

        for code in samples {
            let data = Data()
            
            guard let result = try? ProductMapper.map(data: data, from: anyHttpResponse(statusCode: code)) else {
                return
            }
            
            XCTFail("Expected receive error but got \(result)")
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        let invalidJSON = makeInvalidJson()

        guard let result = try? ProductMapper.map(data: invalidJSON, from: anyHttpResponse(statusCode: 200)) else {
            return
        }
        XCTFail("Expected receive error but got \(result)")
    }
    
    func test_load_deliversOn200HTTPEmptyResponse() async {
        let emptyListJSON = makeEmptyListJson()
        
        do {
            let result = try ProductMapper.map(data: emptyListJSON, from: anyHttpResponse(statusCode: 200))
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Expected result instead of \(error)")
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() async {
        let product1 = makeProduct(1, title: "string", price: 100, description: "string", category: "string", image: "http://example.com")
        let product2 = makeProduct(2, title: "string", price: 100, description: "string", category: "string", image: "http://example.com")
        let validJson = makeProductsJson([product1.json, product2.json])
        
        do {
            let result = try ProductMapper.map(data: validJson, from: anyHttpResponse(statusCode: 200))
            XCTAssertEqual(result, [product1.model, product2.model])
        } catch {
            XCTFail("expected result, got \(error)")
        }
    }
    
    
    // MARK: - Helpers
    private func makeProductsJson(_ products: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: products)
    }
    
}
