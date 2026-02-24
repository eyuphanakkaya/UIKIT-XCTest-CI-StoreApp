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
    
    func test_load_deliverErrorOnClientError() async {
        let error = NSError(domain: "Test", code: 0)
        let (sut, _) = makeSUT(result: .failure(error))
        
        await expect(sut: sut, toCompleteWithError: .connectivity)
    }
    
    func test_load_deliverErrorOnNon200HTTPResponse() async {
        let samples = [199,201,300,400,500]

        for code in samples {
            let data = Data()
            let response = anyHttpResponse(statusCode: code)
            let (sut, _) = makeSUT(result: .success((data, response)))
            
            await expect(sut: sut, toCompleteWithError: .invalidData)
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        let (sut, _) = makeSUT(result: .success(makeInvalidJsonResponse()))
        
        await expect(sut: sut, toCompleteWithError: .invalidData)
    }
    
    @MainActor
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() async {
        let product1 = makeProduct(1, title: "string", price: 100, description: "string", category: "string", image: "http://example.com")
        let validJSON = makeProductDetailJson(product1.json)
        let (sut, _) = makeSUT(result: .success((validJSON, anyHttpResponse(statusCode: 200))))
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, product1.model)
        } catch {
            XCTFail("Expected result but got \(error)")
        }
    }
    
    
    // MARK: - Helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>, url: URL = .init(string: "https://example.com")!) -> (ProductDetailService, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = ProductDetailService(client: client, url: url)
        return (sut, client)
    }
    
    private func expect(sut: ProductDetailService, toCompleteWithError errors: ProductDetailService.ProductDetailError) async {
        do {
            let result = try await sut.load()
            XCTFail("Expected error, got \(result)")
        } catch {
            XCTAssertEqual(error as? ProductDetailService.ProductDetailError, errors)
        }
    }
    
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
