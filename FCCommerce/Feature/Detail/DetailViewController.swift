//
//  DetailViewController.swift
//  FCCommerce
//
//  Created by joe on 10/1/26.
//

import SwiftUI

final class DetailViewController: UIViewController {
    let viewModel = DetailViewModel()
    lazy var rootView = UIHostingController(rootView: DetailRootView(viewModel: viewModel))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRootView()
    }
    
    private func addRootView() {
        addChild(rootView)
        view.addSubview(rootView.view)
        
        rootView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.view.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
