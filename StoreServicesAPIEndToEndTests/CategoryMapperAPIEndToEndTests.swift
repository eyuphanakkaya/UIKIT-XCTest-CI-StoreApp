//
//  CategoryServiceAPIEndToEndTests.swift
//  StoreServicesAPIEndToEndTests
//
//  Created by Eyüphan Akkaya on 25.02.2026.
//

import XCTest
import Store_App

@MainActor
final class CategoryMapperAPIEndToEndTests: XCTestCase {
    func test_endToEndTestServerGetResult_matchesFixedTestAccountData() async {
        let sut = makeSUT()
        
        do {
            let result = try await sut.load()
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
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RemoteLoader<[String]>  {
        let testServerURL = URL(string: "https://fakestoreapi.com/products/categories")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let service = RemoteLoader(client: client, url: testServerURL, closure: { data, response in
            try CategoryMapper.map(data: data, from: response)
        })
        
        trackForMemoryLeaks(service, file: file, line: line)
//        trackForMemoryLeaks(client, file: file, line: line)
        
        return service
    }
    
    private func expectedItem(at index: Int) -> String {
        return name(at: index)
    }
    
    private func name(at index: Int) -> String {
        return ["electronics", "jewelery", "men's clothing", "women's clothing"][index]
    }

}
