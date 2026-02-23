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
    
    // MARK: - Helpers
    
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>, url: URL = .init(string: "https://example.com")!) -> (ProductsService, HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = ProductsService(client: client, url: url)
        return (sut, client)
    }
}
