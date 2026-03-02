//
//  RemoteLoaderTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 26.02.2026.
//

import XCTest
import Store_App

@MainActor
final class RemoteLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() async {
        let (_ , client) = makeSUT(result: anySuccessfulResult())
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // We are just checking load method into Service layer
    func test_load_requestsDataFromURL() async throws {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(result: anySuccessfulResult(), url: url)
        
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // If we have called 2 time load in Service layer we should have an error .
    func test_loadTwice_requestsDataFromURLTwice() async throws {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(result: anySuccessfulResult(), url: url)
        
        _ = try await sut.load()
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url], "expected to make 2 requests")
    }
    
    // when client catched error we should taken error either
    func test_load_deliversErrorOnClientError() async {
        let (sut, _) = makeSUT(result: .failure(anyError()))
        
        await expect(sut, toCompleteWithError: .connectivity)
    }
    
    
    func test_load_deliveryDataOnSuccess() async {
        let expectedData = "hello".data(using: .utf8)!
        let (sut, _) = makeSUT(result: .success((expectedData, anyHttpResponse(statusCode: 200)))) { data, _ in
            String(data: data, encoding: .utf8)!
        }
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, String(data: expectedData, encoding: .utf8))
        } catch {
            XCTFail("Expected to succeed but got: \(error)")
        }
    }
    
    func test_load_deliversErrorOnMapperError() async {
        let mapperError = NSError(domain: "mapper error", code: 0)
        let anyData = "any".data(using: .utf8)!

        let (sut, _) = makeSUT(result: .success((anyData, anyHttpResponse(statusCode: 200)))) { data, _ in
            throw mapperError
        }
        
        do {
            let result = try await sut.load()
            XCTFail("Expected to fail but got: \(result)")
        } catch {
            XCTAssertEqual(error as? RemoteLoader<String>.Error, .invalidData)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>, mapper: @escaping RemoteLoader<String>.Mapper = { _, _ in "any" },url: URL = URL(string: "https://example.com")!, file: StaticString = #filePath, line: UInt = #line) -> (RemoteLoader<String>, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteLoader<String>(client: client, url: url, closure: mapper)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut,client)
    }
    
    private final class HTTPClientSpy: HTTPClient {
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
    
    private func expect(_ sut: RemoteLoader<String>,toCompleteWithError errors: RemoteLoader<String>.Error, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(errors)",file: file, line: line)
        } catch {
            XCTAssertEqual(error as? RemoteLoader.Error, errors, file: file, line: line)
        }
    }
    
    private func anySuccessfulResult() -> Result<(Data, HTTPURLResponse), Error> {
        .success((Data(), anyHttpResponse(statusCode: 200)))
    }

    private struct AnyError: Error {}
    
    private func anyError() -> Error {
        AnyError()
    }

}
