//
//  NSCollectionLayoutSection + Ext.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 9.02.2026.
//

import UIKit

extension NSCollectionLayoutSection {
    static func fillWidth(heightDimension: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    static func custom(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    static func customTwoGrid(
           height: CGFloat,
           itemSpacing: CGFloat,
           sectionInset: CGFloat
       ) -> NSCollectionLayoutSection {

           let itemSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(0.5),
               heightDimension: .fractionalHeight(1.0)
           )

           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           item.contentInsets = NSDirectionalEdgeInsets(
               top: 8,
               leading: itemSpacing,
               bottom: 8,
               trailing: itemSpacing
           )

           let groupSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .absolute(height)
           )

           let group = NSCollectionLayoutGroup.horizontal(
               layoutSize: groupSize,
               subitems: [item, item]
           )

           let section = NSCollectionLayoutSection(group: group)
           section.contentInsets = NSDirectionalEdgeInsets(
               top: sectionInset,
               leading: sectionInset,
               bottom: sectionInset,
               trailing: sectionInset
           )

           return section
       }
}
