//
//  ProductHeroView.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 30.01.2026.
//

import UIKit
import SnapKit
import SDWebImage

final class ProductHeroView: UIStackView {
    // MARK: - Components
    private let imageContainerView = UIView()
    private let productImageView = UIImageView()
    private let titleContainerView = UIView()
    private let titleLabel = UILabel()
    private let priceContainerView = UIView()
    private let priceLabel = UILabel()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with product: ProductResponse) {
        productImageView.sd_setImage(with: URL(string: product.image))
        titleLabel.text = product.title
        priceLabel.text = product.priceFormatted()
    }
}

// MARK: - UI Helpers
private extension ProductHeroView {
    func setupUI() {
        setupConstraints()
        
        axis = .vertical
        spacing = 8
    }
    
    func setupConstraints() {
        addArrangedSubviews(imageContainerView, titleContainerView, priceContainerView)
        setupImageView()
        setupTitleContainerView()
        setupPriceContainerView()
    }
    
    func setupImageView() {
        imageContainerView.backgroundColor = #colorLiteral(red: 0.9763695598, green: 0.9763694406, blue: 0.9763695598, alpha: 1)
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        
        imageContainerView.addSubview(productImageView)
    
        
        productImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setupTitleContainerView() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        titleContainerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    func setupPriceContainerView() {
        priceLabel.font = .systemFont(ofSize: 24)
        priceLabel.numberOfLines = 0
        
        priceContainerView.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}
