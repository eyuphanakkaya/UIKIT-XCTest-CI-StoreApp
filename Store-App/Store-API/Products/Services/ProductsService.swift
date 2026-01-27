//
//  ProductsService.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation

final class ProductsService {
    private let client: HTTPClient
    private let url: URL
    
    
    public enum ProductsServiceError: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    
    func load(completion: @escaping(Result<[ProductResponse],Error>)-> Void) {
        client.get(url) { [weak self] result in
            guard let self else {return}
            switch result {
            case let .success(( data, response)):
                completion(map(data, from: response))
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result<[ProductResponse],Error>{
        do {
            let item = try ProductMapper().map(data: data, from: response)
            return .success(item)
        } catch let error {
            return .failure(error)
        }
    }
}
