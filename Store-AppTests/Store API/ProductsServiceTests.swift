//
//  ProductsServiceTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 20.02.2026.
//

import XCTest
import Store_App

final class ProductsServiceTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() async {
        let (_, client) = makeSUT(.success(anyValidResponse()))
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() async throws {
        let (sut, client) = makeSUT(.success(emptyListResponse()))
        
        _ = try await sut.load()
        
        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_loadTwice_requestsDataFromURL() async throws {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(.success(emptyListResponse()), url: url)
        
        _ = try await sut.load()
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() async {
        let error = NSError(domain: "Test", code: 0)
        let (sut, _) = makeSUT(.failure(error))
        
        await expect(sut: sut, toCompleteWithError: .connectivity)
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() async {
        let samples = [199,201,300,400,500]

        for code in samples {
            let data = Data()
            let (sut, _) = makeSUT(.success((data, anyHttpResponse(statusCode: code))))
            
            await expect(sut: sut, toCompleteWithError: .invalidData)
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        let (sut, _) = makeSUT(.success(makeInvalidJsonResponse()))
        
        await expect(sut: sut, toCompleteWithError: .invalidData)
    }
    
    func test_load_deliversOn200HTTPEmptyResponse() async {
        let (sut, _) = makeSUT(.success(emptyListResponse()))
        
        do {
            let result = try await sut.load()
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Expected result instead of \(error)")
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() async {
        let product1 = makeProduct(1, title: "string", price: 100, description: "string", category: "string", image: "http://example.com")
        let product2 = makeProduct(2, title: "string", price: 100, description: "string", category: "string", image: "http://example.com")
        let validJson = makeProductsJson([product1.json, product2.json])
        let on200Response = (validJson, anyHttpResponse(statusCode: 200))
        let (sut, _) = makeSUT(.success(on200Response))
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [product1.model, product2.model])
        } catch {
            XCTFail("expected result, got \(error)")
        }
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(_ result: Result<(Data, HTTPURLResponse), Error>, url: URL = URL(string: "https://example.com")!, file: StaticString = #file, line: UInt = #line) -> (ProductsService, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = ProductsService(client: client, url: url)
        
        trackForMemoryLeaks(sut)
        
        return (sut, client)
    }
    
    private func expect(sut: ProductsService, toCompleteWithError errors: ProductsService.ProductsServiceError, file: StaticString = #file, line: UInt = #line) async {
        do {
            let result = try await sut.load()
            XCTFail("Expected error instead of \(result)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? ProductsService.ProductsServiceError, errors, file: file, line: line)
        }
    }
    
    private func makeProduct(_ id: Int, title: String, price: Double, description: String, category: String, image: String)
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
    
    private func makeProductsJson(_ products: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: products)
    }
    
}
