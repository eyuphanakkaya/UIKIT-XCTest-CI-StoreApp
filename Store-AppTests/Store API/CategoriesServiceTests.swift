//
//  CategroiesServiceTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 17.02.2026.
//

import Foundation
import XCTest
import Store_App


final class CategoriesServiceTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() async throws {
        let (_ , client) = makeSUT(result: .success(anyValidResponse()))
        
        try await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // We are just checking load method into Service layer
    func test_load_requestsDataFromURL() async throws {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(result: .success(anyValidResponse()), url: url)
        
        _ = try? await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // If we have called 2 time load in Service layer we should have an error .
    func test_loadTwice_requestsDataFromURLTwice() async throws {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(result: .success(anyValidResponse()), url: url)
        
        _ = try? await sut.load()
        _ = try? await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url], "expected to make 2 requests")
    }
    
    // when client catched error we should taken error either
    func test_load_deliversErrorOnClientError() async throws {
        let (sut, _) = makeSUT(result: .failure(anyError()))
        
        await expect(sut, toCompleteWithError: .connectivity)
    }
    

    func test_load_deliversErrorOnNon200HTTPResponse() async throws {
        let samples = [199,201,300,400,500]
        for code in samples {
            let non200Response = (Data(),anyHttpResponse(statusCode: code))
            let (sut, _) = makeSUT(result: .success((non200Response)))
            
            await expect(sut, toCompleteWithError: .invalidData)
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async throws {
        let invalidJson = Data("invalid json".utf8)
        let non200Response = (invalidJson,anyHttpResponse(statusCode: 200))
        let (sut, _) = makeSUT(result: .success((non200Response)))
        
        await expect(sut, toCompleteWithError: .invalidData)
    }
    
    // MARK: - Helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>,url: URL = URL(string: "https://example.com")!) -> (CategoryService, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = CategoryService(client: client, url: url)
        
        return (sut,client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [URL]()
        private let result: Result<(Data, HTTPURLResponse), Error>
        
        var requestedURLs: [URL] {
            messages
        }
        
        init(result: Result<(Data, HTTPURLResponse), Error>) {
            self.result = result
        }
        
        func get(_ url: URL) async throws -> (Data, HTTPURLResponse) {
            messages.append(url)
            return try result.get()
        }
    }
    
    private func expect(_ sut: CategoryService,toCompleteWithError errors: CategoryService.CategoryServiceError, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(errors)")
        } catch {
            XCTAssertEqual(error as? CategoryService.CategoryServiceError, errors, file: file, line: line)
        }
    }
    
    private struct AnyError: Error {}
    
    private func anyError() -> Error {
        AnyError()
    }
    
    private func anyValidResponse() -> (Data, HTTPURLResponse) {
        return (Data(), anyHttpResponse(statusCode: 200))
    }
    
    private func anyHttpResponse(statusCode: Int) -> HTTPURLResponse {
        let url = URL(string: "https://example.com")!
        return HTTPURLResponse(url:  url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    

}
