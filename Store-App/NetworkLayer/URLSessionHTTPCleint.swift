//
//  URLSessionHTTPCleint.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 18.01.2026.
//

import Foundation


final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(_ url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
    
}
