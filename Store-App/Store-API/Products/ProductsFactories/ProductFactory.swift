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
        
        let service = ProductsService(client: client, url: url)
        let storage = UserDefaultManager()
        let viewModel = ProductsVM(service: service, storage: storage)
        let vc = ProductsVC(viewModel: viewModel, headerTitle: categoryName)
        return vc
    }
}
