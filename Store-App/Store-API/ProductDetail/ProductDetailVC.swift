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
        collectionViewLayout: LayoutMaker().makeLayout())
    
    private let viewModel: ProductDetailsVM
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        setupCollectionView()
        
        viewModel.onSuccess = { [weak self]  in
            self?.collectionView.reloadData()
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
        collectionView.delegate = self
    }
}

extension ProductDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
            let cell = collectionView.dequeueCell(cellClass: ProductHeroCell.self, for: indexPath)
            
            if let product = viewModel.productDetails { cell.configure(with: product) }
            
            cell.addActionButtonHandler = { [weak self] in
                self?.viewModel.toggleAddToCart(productID: self?.viewModel.productDetails?.convertToIdString)
            }
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueCell(cellClass: ProductCollectionViewCell.self, for: indexPath)
            let product = viewModel.products?[indexPath.item]
            cell.configure(to: product)
            
            cell.onAddToCartHandler = { [weak self] in
                self?.viewModel.toggleAddToCart(productID: product?.convertToIdString)
                self?.collectionView.reloadItems(at: [indexPath])
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 1, let productItem = viewModel.products?[indexPath.item] {
            let viewController = ProductDetailFactory().makeViewController(id: productItem.id, title: productItem.title)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

private extension ProductDetailVC {
    func setupView() {
        view.backgroundColor = .white
        title = viewModel.title
    }
}
