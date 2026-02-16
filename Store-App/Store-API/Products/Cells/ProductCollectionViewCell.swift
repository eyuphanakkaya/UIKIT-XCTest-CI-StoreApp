//
//  ProductCollectionViewCell.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 27.01.2026.
//

import UIKit
import SnapKit
import SDWebImage

final class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCollectionViewCell"
    
    private let stackView = UIStackView()
    private let imageView = UIView()
    private let image = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private var addActionView = AddActionView()
    
    var onAddToCartHandler: (() -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        addActionViewTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(to product: ProductResponse?) {
        guard let product else { return }
        image.sd_setImage(with: URL(string: product.image))
        titleLabel.text = product.title
        priceLabel.text = product.priceFormatted()
        addActionView.isButtonSelected = product.isAdded
    }
    
    
    // MARK: - Actions
    private func addActionViewTapped() {
        addActionView.onAddToCart = { [weak self] in
            self?.onAddToCartHandler?()
        }
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
        
        stackView.addArrangedSubviews(imageView, titleLabel, priceLabel, addActionView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.numberOfLines = 1
        
        addActionView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        addActionView.editButtonTitleSize(to: 12)
        
        setupImageView()
    }
    
    func setupImageView() {
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
    }
}
