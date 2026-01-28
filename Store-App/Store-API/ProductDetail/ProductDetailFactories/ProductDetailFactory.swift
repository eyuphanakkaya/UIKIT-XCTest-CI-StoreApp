//
//  ProductDetailFactory.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import Foundation
import UIKit

final class ProductDetailFactory {
    func makeViewController() -> UIViewController {
        let viewController = ProductDetailVC()
        return viewController
    }
}
