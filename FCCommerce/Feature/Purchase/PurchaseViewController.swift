//
//  PurchaseViewController.swift
//  FCCommerce
//
//  Created by joe on 10/4/26.
//

import UIKit
import Combine

final class PurchaseViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel = PurchaseViewModel()
    private var rootView = PurchaseRootView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        bindViewModel()
        viewModel.process(.loadData)
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let viewModels = self?.viewModel.state.purchaseItems else { return }
                self?.rootView.setPurchaseItem(viewModels)
            }
            .store(in: &cancellables)
        
        viewModel.showPaymentViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let paymentViewController = PaymentViewController()
                self?.navigationController?.pushViewController(paymentViewController, animated: true)
            }
            .store(in: &cancellables)
    }
}

#Preview {
    PurchaseViewController()
}
