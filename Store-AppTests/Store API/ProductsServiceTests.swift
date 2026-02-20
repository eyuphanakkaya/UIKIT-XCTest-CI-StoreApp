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
    
    
    // MARK: - Helpers
    
    private func makeSUT(_ result: Result<(Data, HTTPURLResponse), Error>, url: URL = URL(string: "https://example.com")!, file: StaticString = #file, line: UInt = #line) -> (ProductsService, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = ProductsService(client: client, url: url)
        
        trackForMemoryLeaks(sut)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        private let result: Result<(Data, HTTPURLResponse), Error>
        
        init(result: Result<(Data, HTTPURLResponse), Error>) {
            self.result = result
        }
        
        func get(_ url: URL) async throws -> (Data, HTTPURLResponse) {
            requestedURLs.append(url)
            return try result.get()
        }
    }
    
    private func emptyListResponse() -> (Data, HTTPURLResponse) {
        let emptyListJSON = "[]".data(using: .utf8)!
        return (emptyListJSON, anyHttpResponse(statusCode: 200))
    }
    
    private func anyValidResponse() -> (Data, HTTPURLResponse) {
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
    
    private func anyHttpResponse(statusCode: Int) -> HTTPURLResponse {
        let url = URL(string: "https://example.com")!
        return HTTPURLResponse(url:  url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
}
