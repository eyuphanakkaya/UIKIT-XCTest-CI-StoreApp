//
//  ProductHeroCell.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 8.02.2026.
//


import UIKit
import SnapKit

final class ProductHeroCell: UICollectionViewCell {

    static let reuseIdentifier = "ProductHeroCell"

    
    // MARK: - Components
    private let productHeroView = ProductHeroView()
    private let addActionView = AddActionView()
    private let descriptionView = DescriptionView()
    private let stackView = UIStackView()
    
    var addActionButtonHandler: (()->Void)?

    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addActionButtonTapped()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func configure(with product: ProductResponse) {
        productHeroView.configure(with: product)
        productHeroView.configure(with: product)
        descriptionView.configure(with: product.description)
        addActionView.isButtonSelected = product.isAdded
    }
    
    // MARK: - Button Actions
    private func addActionButtonTapped() {
        addActionView.onAddToCart = { [weak self] in
            self?.addActionButtonHandler?()
        }
    }
}

// MARK: - UI Helpers
private extension ProductHeroCell {
    func setupView() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(stackView)
        
        stackView.addArrangedSubviews(productHeroView, addActionView, descriptionView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addActionView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
