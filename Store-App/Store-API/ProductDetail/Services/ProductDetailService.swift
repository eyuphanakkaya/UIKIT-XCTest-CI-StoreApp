//
//  ProductDetailService.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation


final class ProductDetailService {
    private let httpClient: HTTPClient
    private let url: URL
    
    init(httpClient: HTTPClient, url: URL, ) {
        self.httpClient = httpClient
        self.url = url
    }
    
    public enum ProductDetailError: Error {
        case invalidData
    }
    
    func load(completion: @escaping (Result<ProductResponse,Error>)-> Void) {
        httpClient.get(url) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case let .success((data, response)):
                completion(map(data, response))
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func map(_ data: Data,_ response: HTTPURLResponse)-> Result<ProductResponse,Error> {
        do {
            let item = try ProductDetailMapper().map(data: data, from: response)
            return .success(item)
        } catch let error {
            return .failure(error)
        }
    }
}
