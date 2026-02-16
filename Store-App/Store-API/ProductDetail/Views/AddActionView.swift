//
//  AddActionView.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 30.01.2026.
//

import UIKit
import SnapKit


final class AddActionView: UIView {
    
    private let addToCartButton = UIButton()
    
    var onAddToCart: (() -> Void)?
    var isButtonSelected: Bool = false {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        addToCartButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editButtonTitleSize(to size: CGFloat) {
        addToCartButton.titleLabel?.font = .systemFont(ofSize: size)
    }
    
    func configure() {
        let title = isButtonSelected == true ? "Added" : "Add to cart"
        addToCartButton.setTitle(title, for: .normal)
        
        let color: UIColor = isButtonSelected == true ? .lightGray : .black
        addToCartButton.backgroundColor = color
    }
    
    //  MARK: - Actions
    private func addToCartButtonTapped() {
        addToCartButton.addAction { [weak self] in
            self?.onAddToCart?()
        }
    }
}

private extension AddActionView {
    func setupUI() {
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(addToCartButton)
        
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.backgroundColor = .black
        addToCartButton.setTitleColor(.white, for: .normal)
        
        addToCartButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
