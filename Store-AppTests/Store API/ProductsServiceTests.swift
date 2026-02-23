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
        let data = Data("invalid data".utf8)
        let response = anyHttpResponse(statusCode: 200)
        let (sut, _) = makeSUT(.success((data, response)))
        
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
    
    private func expect(sut: ProductsService, toCompleteWithError errors: ProductsService.ProductsServiceError, file: StaticString = #file, line: UInt = #line) async {
        do {
            let result = try await sut.load()
            XCTFail("Expected error instead of \(result)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? ProductsService.ProductsServiceError, errors, file: file, line: line)
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
