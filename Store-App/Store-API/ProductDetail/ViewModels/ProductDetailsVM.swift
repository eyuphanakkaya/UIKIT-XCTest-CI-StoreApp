//
//  ProductDetailsVM.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation

@MainActor
final class ProductDetailsVM {
    private let detailService: ProductDetailService
    private let productsService: ProductsService
    
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
    
    init(detailService: ProductDetailService, productsService: ProductsService, title: String) {
        self.detailService = detailService
        self.productsService = productsService
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
            } catch {
                print(error)
            }
        }
    }
    
}
