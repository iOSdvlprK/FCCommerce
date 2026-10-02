//
//  OptionViewController.swift
//  FCCommerce
//
//  Created by joe on 10/2/26.
//

import SwiftUI

final class OptionViewController: UIViewController {
    let viewModel = OptionViewModel()
    lazy var rootView = UIHostingController(rootView: OptionRootView(viewModel: viewModel))
    
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
