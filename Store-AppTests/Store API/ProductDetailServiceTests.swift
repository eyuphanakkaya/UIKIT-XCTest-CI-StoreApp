//
//  ProductDetailServiceTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//

import Foundation
import XCTest
import Store_App


final class ProductDetailServiceTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() async {
        let (_, client) = makeSUT(result: .success(anyValidResponse()))
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() async throws {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(result: .success(validProductDetailResponse()), url: url)
        
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURL() async throws {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(result: .success(validProductDetailResponse()), url: url)
        
        _ = try await sut.load()
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>, url: URL = .init(string: "https://example.com")!) -> (ProductDetailService, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = ProductDetailService(client: client, url: url)
        return (sut, client)
    }
    
    
    func validProductDetailResponse() -> (Data, HTTPURLResponse) {
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
