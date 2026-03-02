//
//  HTTPClientSpy.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 23.02.2026.
//
import UIKit
import Store_App


final class HTTPClientSpy: HTTPClient {
    var requestedURLs = [URL]()
    private let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func get(_ url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try result.get()
    }
}
