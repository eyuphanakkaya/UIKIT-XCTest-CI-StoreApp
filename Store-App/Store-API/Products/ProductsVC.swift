//
//  ProductsVC.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 20.01.2026.
//

import SnapKit
import UIKit

final class ProductsVC: UIViewController {
    // MARK: - Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none

        return collectionView
    }()
    
    private let viewModel: ProductsVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()

        setupCollectionView()
        setupUI()
    }
    
    // MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onSuccess = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onFailure = {  error in
            print(error)
        }
    }
    
    // MARK: - Initializer
    init(viewModel: ProductsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    private func navigateToProductDetails(productId: Int, productTitle: String) {
        let viewController = ProductDetailFactory().makeViewController(id: productId, title: productTitle)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - UI Helpers

private extension ProductsVC {
    func setupUI() {
        view.backgroundColor = .white
        title = "Products"
    }
    
    func setupConstraints() {
        
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ProductsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        let product = viewModel.products[indexPath.row]
        cell.configure(to: product)
        
        
        cell.onAddToCartHandler = { [weak self] in
            self?.viewModel.toggleAddToCart(productID: product.convertToIdString)
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let product = viewModel.products[indexPath.row]
        navigateToProductDetails(productId: product.id,productTitle: product.title)
    }
}

extension ProductsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 8
        let padding: CGFloat = 4 * 2
        
        let totalSpacing = (itemsPerRow - 1) * spacing + padding
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / itemsPerRow
        
        return CGSize(width: cellWidth, height: cellWidth + 40)
    }
}
