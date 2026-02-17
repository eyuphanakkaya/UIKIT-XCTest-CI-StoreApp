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
        let (_ , client) = makeSUT()
        
        try await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://example.com")!) -> (CategoryService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = CategoryService(client: client, url: url)
        
        return (sut,client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [URL]()
        var requestedURLs: [URL] {
            messages
        }
        
        func get(_ url: URL) async throws -> (Data, HTTPURLResponse) {
            messages.append(url)
            
            return (Data(), HTTPURLResponse())
        }
    }
    

}
