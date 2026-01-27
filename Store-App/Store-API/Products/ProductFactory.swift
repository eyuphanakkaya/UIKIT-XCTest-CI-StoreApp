//
//  ProductFactory.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import Foundation
import UIKit

final class ProductFactory {
    func makeViewController() -> UIViewController {
        let client = URLSessionHTTPClient()
        let urlString = APIConstants.baseURL + "products"
        let url = URL(string: urlString)!
        
        let service = ProductsService(client: client, url: url)
        let viewModel = ProductsVM(service: service)
        let vc = ProductsVC(viewModel: viewModel)
        return vc
    }
}
