//
//  ProductFactory.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation
import UIKit

final class ProductFactory {
    func makeViewController(_ categoryName: String) -> UIViewController {
        let client = URLSessionHTTPClient()
        let urlString = APIConstants.baseURL + "category/\(categoryName.lowercased())"
        let url = URL(string: urlString)!
        
        let service = RemoteLoader<[ProductResponse]>(client: client, url: url, closure: { data, response in
            try ProductMapper.map(data: data, from: response)
        })
        let storage = UserDefaultManager()
        let viewModel = ProductsVM(service: service, storage: storage)
        let vc = ProductsVC(viewModel: viewModel, headerTitle: categoryName)
        return vc
    }
}
