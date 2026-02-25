//
//  CategoryServiceAPIEndToEndTests.swift
//  StoreServicesAPIEndToEndTests
//
//  Created by Eyüphan Akkaya on 25.02.2026.
//

import XCTest
import Store_App

@MainActor
final class CategoryServiceAPIEndToEndTests: XCTestCase {
    func test_endToEndTestServerGetResult_matchesFixedTestAccountData() async {
        let testServerURL = URL(string: "https://fakestoreapi.com/products/categories")!
        let client = URLSessionHTTPClient()
        let service = CategoryService(client: client, url: testServerURL)
        
        do {
            let result = try await service.load()
            XCTAssertEqual(result.count, 4)
            XCTAssertEqual(result[0], expectedItem(at: 0))
            XCTAssertEqual(result[1], expectedItem(at: 1))
            XCTAssertEqual(result[2], expectedItem(at: 2))
            XCTAssertEqual(result[3], expectedItem(at: 3))

            
        } catch {
            XCTFail("Expected result, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    private func expectedItem(at index: Int) -> String {
        return name(at: index)
    }
    
    private func name(at index: Int) -> String {
        return ["electronics", "jewelery", "men's clothing", "women's clothing"][index]
    }

}
