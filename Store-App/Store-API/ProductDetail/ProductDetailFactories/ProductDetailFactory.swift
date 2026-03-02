//
//  ProductDetailFactory.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation
import UIKit

final class ProductDetailFactory {
    func makeViewController(id: Int, title: String) -> UIViewController {
        let httpClient = URLSessionHTTPClient()
        let detailUrl = URL(string: APIConstants.baseURL + "\(id)")!
        let productsUrl = URL(string: APIConstants.baseURL)!
        
        let detailService = RemoteLoader<ProductResponse>(client: httpClient, url: detailUrl, closure: { data, response in
            try ProductDetailMapper.map(data: data, from: response)
        })
        
        let productsService = RemoteLoader<[ProductResponse]>(client: httpClient, url: productsUrl, closure: { data, response in
            try ProductMapper.map(data: data, from: response)
        })
        let storage = UserDefaultManager()
        
        let viewModel = ProductDetailsVM(detailService: detailService, productsService: productsService, title: title, storage: storage)
        let viewController = ProductDetailVC(viewModel: viewModel)
        return viewController
    }
}
