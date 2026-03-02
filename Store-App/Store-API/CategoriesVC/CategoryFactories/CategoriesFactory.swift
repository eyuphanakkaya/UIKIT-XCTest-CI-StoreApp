//
//  CategoriesFactory.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 26.01.2026.
//

import Foundation
import UIKit


final class CategoriesFactory {
    func makeViewController() -> UIViewController {
        let client = URLSessionHTTPClient()
        let url = URL(string: APIConstants.baseURL + "categories")!
        
        let service = RemoteLoader(client: client,
                                   url: url,
                                   closure: { data, response in
            try CategoryMapper.map(data: data, from: response)
        })
        
        let viewModel = CategoryVM(service: service)
        
        let viewController = CategoriesVC(viewModel: viewModel)
        return viewController
    }
}
