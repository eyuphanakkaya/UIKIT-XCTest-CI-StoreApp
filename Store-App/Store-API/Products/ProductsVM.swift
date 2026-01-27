//
//  ProductsVM.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 27.01.2026.
//

import Foundation


final class ProductsVM {
    private let service: ProductsService
    
    init(service: ProductsService) {
        self.service = service
    }
    
    func viewWillAppear() {
        load()
    }
    
    private func load() {
        service.load { result in
            switch result {
            case .success(let response):
                response.forEach { item in
                    print(item)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
