//
//  ProductDetailMapperAPIEndToEndTests.swift
//  StoreServicesAPIEndToEndTests
//
//  Created by Eyüphan Akkaya on 27.02.2026.
//

import XCTest
import Store_App

@MainActor
final class ProductDetailMapperAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGetResult_matchesFixedTestAccountData() async {
        let sut = makeSUT()
        
        do {
            let result = try await sut.load()
            
            XCTAssertNotNil(result)
            
            XCTAssertEqual(result, expectedItem())
        } catch {
            XCTFail("Expected to result but got \(error)")
        }
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> RemoteLoader<ProductResponse> {
        let url = URL(string: "https://fakestoreapi.com/products/1")!
        let client = URLSessionHTTPClient()
        let sut = RemoteLoader<ProductResponse>(client: client, url: url, closure: { data, response in
            try ProductDetailMapper.map(data: data, from: response)
        })
        
        return sut
    }
    
    
    private func expectedItem() -> ProductResponse {
        return ProductResponse(id: 1,
                               title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                               price: 109.95,
                               description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                               category: "men's clothing",
                               image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png", isAdded: false)
    }

}
