//
//  UICollectionView+Ext.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 9.02.2026.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
