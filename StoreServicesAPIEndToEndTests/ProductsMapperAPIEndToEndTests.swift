//
//  ProductsServiceAPIEndToEndTests.swift
//  StoreServicesAPIEndToEndTests
//
//  Created by Eyüphan Akkaya on 25.02.2026.
//

import XCTest
import Store_App


@MainActor
final class ProductsMapperAPIEndToEndTests: XCTestCase {
    func test_endToEndTestServerGetResult_matchesFixedTestAccountData() async {
        let sut = makeSUT()
        
        do {
            let result = try await sut.load()
            
            XCTAssertFalse(result.isEmpty)
            
            XCTAssertEqual(result[0], expectedItem(at: 0))
            XCTAssertEqual(result[1], expectedItem(at: 1))
            XCTAssertEqual(result[2], expectedItem(at: 2))
            XCTAssertEqual(result[3], expectedItem(at: 3))
            
        } catch {
            XCTFail("Expected result, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RemoteLoader<[ProductResponse]> {
        let url = URL(string: "https://fakestoreapi.com/products/category/men's clothing")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let sut = RemoteLoader<[ProductResponse]>(client: client, url: url, closure: { data, response in
            try ProductMapper.map(data: data, from: response)
        })
        
        trackForMemoryLeaks(client,file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expectedItem(at index: Int) -> ProductResponse {
        return ProductResponse(id: id(at: index), title: title(at: index), price: price(at: index), description: description(at: index), category: category(at: index), image: image(at: index), isAdded: false)
    }
    
    private func id(at index: Int) -> Int {
        return [
            1, 2, 3, 4, 5
        ][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops"
            , "Mens Casual Premium Slim Fit T-Shirts "
            , "Mens Cotton Jacket"
            , "Mens Casual Slim Fit"
        ][index]
    }
    
    private func price(at index: Int) -> Double {
        return [
            109.95
            , 22.3
            , 55.99
            , 15.99
            
        ][index]
    }
    
    private func description(at index: Int) -> String {
        return [
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday"
            , "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket."
            , "great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors. Good gift choice for you or your family member. A warm hearted love to Father, husband or son in this thanksgiving or Christmas Day."
            , "The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description."
            
        ][index]
    }
    
    private func category(at index: Int) -> String {
        return [
            "men's clothing",
            "men's clothing",
            "men's clothing",
            "men's clothing"
        ][index]
    }
    
    private func image(at index: Int) -> String {
        return [
            "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png"
            , "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png"
            , "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png"
            , "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_t.png"
            
        ][index]
    }
    
}
