//
//  CategoriesVC.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 26.01.2026.
//

import UIKit
import SnapKit

final class CategoriesVC: UIViewController {

    // MARK: - Components
    private let tableView = UITableView()
    private let viewModel: CategoryVM
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()

        navigationItem.title = "Categories"
        
        viewModel.onSuccess = { [weak self] in
            self?.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        setupTableView()
    }
    
    // MARK: - Initializer
    init(viewModel: CategoryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Helper
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Navigator
    private func showToProductVC(_ indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        let vc = ProductFactory().makeViewController(category)
        navigationController?.pushViewController(vc, animated: true)
    }

}
extension CategoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = viewModel.categories[indexPath.row]
        cell.textLabel?.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showToProductVC(indexPath)
    }
}
