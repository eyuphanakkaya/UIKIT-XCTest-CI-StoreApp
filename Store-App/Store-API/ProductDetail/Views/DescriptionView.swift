//
//  DescriptionView.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 30.01.2026.
//

import UIKit
import SnapKit

final class DescriptionView : UIView {
    
    // MARK: - Components
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with description: String) {
        descriptionLabel.text = description
    }
    
}

private extension DescriptionView {
    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel, descriptionLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.text = "Description"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
    }
}
