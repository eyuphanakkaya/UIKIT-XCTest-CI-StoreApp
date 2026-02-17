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
    private let storage: StoreStorage
    var products: [ProductResponse] = []
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    
    init(service: ProductsService, storage: StoreStorage) {
        self.service = service
        self.storage = storage
    }
    
    func viewViewWillAppear() {
        load()
    }
}

extension ProductsVM {
    private func load() {
        Task {
            do {
                let result = try await service.load()
                products = result
                syncCartState()
                onSuccess?()
            } catch {
                onFailure?(error)
            }
        }
    }
    
    func toggleAddToCart(productID: String) {
        guard let index = products.firstIndex(where: { $0.convertToIdString == productID }) else { return }
        cartItemChange(productID)
        products[index].isAdded.toggle()
    }
    
    private func cartItemChange(_ productID: String) {
        let isAdded = isProductInCart(productID)
        
        if isAdded {
            storage.delete(productID)
        } else {
            storage.insert(productID)
        }
    }
    
    private func isProductInCart(_ id: String) -> Bool {
        return storage.retrieve().contains(id)
    }
    
    private func syncCartState() {
        let cartIDs = storage.retrieve()
        
        for index in products.indices {
            let id = products[index].convertToIdString
            products[index].isAdded = cartIDs.contains(id)
        }
    }
}
