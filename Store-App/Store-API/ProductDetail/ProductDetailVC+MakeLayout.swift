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
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(0.5),
                            heightDimension: .fractionalHeight(1.0)
                        )
                    )
                    
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(220)
                        ),
                        subitems: [item, item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                default:
                    return nil
                }
            }
        }
    }
}
