//
//  URLSessionNetwork.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation


final class URLSessionNetwork {
    private let httpClient: HTTPClient
    private let url: URL
    
    public enum ProductDetailError: Error {
        case invalidData
    }
    
    init(httpClient: HTTPClient, url: URL) {
        self.httpClient = httpClient
        self.url = url
    }
    
    func get<T: Decodable>(completion: @escaping(Result<T, Error>)-> Void) {
        httpClient.get(url) { [weak self] result in
            guard let self else {return}
            switch result {
            case let .success((data, response)):
                completion(map(data, from: response))
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func map<T: Decodable>(_ data: Data, from response: HTTPURLResponse) -> Result<T,Error> {
        do {
            let result: T = try map(data: data, response:  response)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    private func map<T: Decodable>(data: Data, response: HTTPURLResponse) throws -> T {
        guard response.statusCode == 200 , let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw ProductDetailError.invalidData
        }
        
        return decoded
    }
}
