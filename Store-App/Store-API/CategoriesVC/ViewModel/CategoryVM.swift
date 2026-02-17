//
//  CategoryVM.swift
//  Store-App
//
//  Created by Eyüphan Akkaya on 17.02.2026.
//

import Foundation

final class CategoryVM {
    private let service: CategoryService
    
    var categories: [String] = []
    var onSuccess: (() -> Void)?
    
    init(service: CategoryService) {
        self.service = service
    }
}

extension CategoryVM {
    func viewDidLoad() {
        load()
    }
    
    private func load() {
        Task {
            do {
                let result = try await service.load()
                categories = result.map{ $0.uppercased()}
                onSuccess?()
            } catch {
                print(error)
            }
        }
    }
}
