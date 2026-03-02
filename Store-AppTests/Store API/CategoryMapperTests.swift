//
//  CategroiesServiceTests.swift
//  Store-AppTests
//
//  Created by Eyüphan Akkaya on 17.02.2026.
//

import Foundation
import XCTest
import Store_App


@MainActor
final class CategoryMapperTests: XCTestCase {

    func test_load_deliversErrorOnNon200HTTPResponse() async {
        let samples = [199,201,300,400,500]
        for code in samples {
            
            guard let result = try? CategoryMapper.map(data: makeItemJson([]), from: anyHttpResponse(statusCode: code)) else {
                return
            }
            XCTFail("Expected receive error but got \(result)")
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        let invalidJSON = makeInvalidJson()
        
        guard let result = try? CategoryMapper.map(data: invalidJSON, from: anyHttpResponse(statusCode: 200)) else {
            return
        }
        XCTFail("Expected receive error but got \(result)")
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJsonList() async {
        let emptyListJSON = makeEmptyListJson()

        do {
            let result = try CategoryMapper.map(data: emptyListJSON, from: anyHttpResponse(statusCode: 200))
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Expected empty but got: \(error)")
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() async {
        let item1 = makeCategory("electronics")
        let item2 = makeCategory("jewelery")
        let validJson = makeItemJson([item1.json, item2.json])
        
        do {
            let result = try CategoryMapper.map(data: validJson, from: anyHttpResponse(statusCode: 200))
            XCTAssertEqual(result, [item1.model,item2.model])
        } catch {
            XCTFail("Expected empty but got: \(error)")
        }
    }
    
    // MARK: - Helpers
    private func makeCategory(_ name: String) -> (model: String, json: String) {
        return (name, name)
    }
    
    private func makeItemJson(_ items: [String]) -> Data {
        try! JSONSerialization.data(withJSONObject: items)
    }
    

}
