//
//  ProductDetail+MakeLayout.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 9.02.2026.
//

import UIKit

extension ProductDetailVC {
    struct LayoutMaker {
        func makeLayout() -> UICollectionViewCompositionalLayout{
            UICollectionViewCompositionalLayout { sectionIndex, environment in
                switch sectionIndex {
                case 0:
                    let section = NSCollectionLayoutSection.fillWidth(heightDimension: .fractionalHeight(1))
                    return section
                case 1:
                    let section = NSCollectionLayoutSection.customTwoGrid(height: 220, itemSpacing: 8, sectionInset: 8)
                    return section
                default:
                    return nil
                }
            }
        }
    }
}
