//
//  ProductDetailVC.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 28.01.2026.
//

import UIKit
import SnapKit

final class ProductDetailVC: UIViewController {
    // MARK: - Components
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout())
    
    private let viewModel: ProductDetailsVM
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        setupCollectionView()
        
        viewModel.onSuccess = { [weak self]  in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // MARK: - Initializer
    init(viewModel: ProductDetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(ProductHeroCell.self, forCellWithReuseIdentifier: ProductHeroCell.reuseIdentifier)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            case 1:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 8, leading: 8, bottom: 8, trailing: 8
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

extension ProductDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.products?.count ?? 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductHeroCell.reuseIdentifier,
                for: indexPath
            ) as! ProductHeroCell
            
            if let product = viewModel.productDetails {
                cell.configure(with: product)
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.identifier,
                for: indexPath
            ) as! ProductCollectionViewCell
            
            let product = viewModel.products?[indexPath.item]
            cell.configure(to: product)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

private extension ProductDetailVC {
    func setupView() {
        view.backgroundColor = .white
        title = viewModel.title
    }
}
