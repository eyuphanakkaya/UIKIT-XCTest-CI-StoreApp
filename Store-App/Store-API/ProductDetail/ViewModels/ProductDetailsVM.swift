//
//  ProductDetailsVM.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation

@MainActor
final class ProductDetailsVM {
    private let detailService: RemoteLoader<ProductResponse>
    private let productsService: RemoteLoader<[ProductResponse]>
    private let storage: StoreStorage
    
    var title: String
    var productDetails: ProductResponse? {
        didSet {
            onSuccess?()
        }
    }
    var products: [ProductResponse]?{
        didSet {
            onSuccess?()
        }
    }
    
    var onSuccess: (() -> Void)?
    
    init(detailService: RemoteLoader<ProductResponse>,
         productsService: RemoteLoader<[ProductResponse]>,
         title: String,
         storage: StoreStorage) {
        
        self.detailService = detailService
        self.productsService = productsService
        self.storage = storage
        self.title = title
    }
    
    func viewWillAppear() {
        detailLoad()
        productsLoad()
    }
    
    private func detailLoad() {
        Task {
            do {
                let result = try await detailService.load()
                productDetails = result
                syncCartState()
            } catch {
                print(error)
            }
        }
    }
    
    private func productsLoad() {
        Task {
            do {
                let result = try await productsService.load()
                products = result
                syncCartState()
            } catch {
                print(error)
            }
        }
    }
    
}
extension ProductDetailsVM {
    func toggleAddToCart(productID: String?) {
        guard let productID else { return }
        cartItemChange(productID)
        
        let isAdded = isProductInCart(productID)
        
        updateLocalState(productID: productID, isAdded: isAdded)
    }
    
    private func updateLocalState(productID: String, isAdded: Bool) {
        if let index = products?.firstIndex(where: { $0.convertToIdString == productID }) {
            products?[index].isAdded = isAdded
        }
        
        if productDetails?.convertToIdString == productID {
            productDetails?.isAdded = isAdded
        }
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
        guard products != nil else { return }
        
        let cartIDs = storage.retrieve()
        
        for index in products!.indices {
            let id = products![index].convertToIdString
            products![index].isAdded = cartIDs.contains(id)
        }
        
        if let detailID = productDetails?.convertToIdString {
            productDetails?.isAdded = cartIDs.contains(detailID)
        }
    }
}
