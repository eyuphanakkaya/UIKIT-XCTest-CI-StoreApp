//
//  UIStackView+Ext.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 27.01.2026.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
