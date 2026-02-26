////
////  ProductDetailService.swift
////  Store-App
////
////  Created by Eyüphan Akkaya on 28.01.2026.
////
//
//import Foundation
//
//
//final public class ProductDetailService: Loader {
//    private let client: HTTPClient
//    private let url: URL
//    
//    public init(client: HTTPClient, url: URL, ) {
//        self.client = client
//        self.url = url
//    }
//    
//    public enum ProductDetailError: Error {
//        case connectivity
//        case invalidData
//    }
//    
//    public func load() async throws -> ProductResponse{
//        guard let (data,response) = try? await client.get(url) else {
//            throw ProductDetailError.connectivity
//        }
//        return try map(data, response)
//    }
//    
//    private func map(_ data: Data,_ response: HTTPURLResponse) throws -> ProductResponse {
//        do {
//            return try ProductDetailMapper().map(data: data, from: response)
//        } catch {
//            throw ProductDetailError.invalidData
//        }
//    }
//}
