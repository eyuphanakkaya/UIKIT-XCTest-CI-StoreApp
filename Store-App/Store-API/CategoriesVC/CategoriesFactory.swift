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
        let viewController = CategoriesVC()
        return viewController
    }
}
