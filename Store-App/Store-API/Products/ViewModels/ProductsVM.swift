//
//  ProductsVM.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 27.01.2026.
//

import Foundation

@MainActor
final class ProductsVM {
    private let service: ProductsService
    var products: [ProductResponse] = []
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    
    init(service: ProductsService) {
        self.service = service
    }
    
    func viewWillAppear() {
        load()
    }
    
    private func load() {
        Task {
            do {
                let result = try await service.load()
                products = result
                onSuccess?()
            } catch {
                onFailure?(error)
            }
        }
    }
}
