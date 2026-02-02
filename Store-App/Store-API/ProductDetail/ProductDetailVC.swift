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
    private let viewModel: ProductDetailsVM
    private let productHeroView = ProductHeroView()
    private let addActionView = AddActionView()
    private let descriptionView = DescriptionView()
    private let stackView = UIStackView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        viewModel.onSuccess = { [weak self] product in
            DispatchQueue.main.async {
                self?.productHeroView.configure(with: product)
                self?.descriptionView.configure(with: product.description)
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
    
}

private extension ProductDetailVC {
    func setupView() {
        view.backgroundColor = .white
        title = viewModel.title
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubviews(productHeroView, addActionView, descriptionView)
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        addActionView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
