//
//  ProductCollectionViewCell.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 27.01.2026.
//

import UIKit
import SnapKit

final class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCollectionViewCell"
    
    private let stackView = UIStackView()
    private let imageView = UIView()
    private let image = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(to product: ProductResponse) {
        titleLabel.text = product.title
        priceLabel.text = product.priceFormatted()
    }
}

private extension ProductCollectionViewCell {
    func setupViews() {
        backgroundColor = #colorLiteral(red: 0.9763695598, green: 0.9763694406, blue: 0.9763695598, alpha: 1)
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        stackView.addArrangedSubviews(imageView, titleLabel, priceLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        imageView.addSubview(image)
        
        image.image = UIImage(named: "disk")
        image.contentMode = .scaleToFill
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(24)
        }
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.numberOfLines = 1
    }
}
