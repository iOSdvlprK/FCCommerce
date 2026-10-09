//
//  PurchaseViewModel.swift
//  FCCommerce
//
//  Created by joe on 10/4/26.
//

import Foundation
import Combine

final class PurchaseViewModel: ObservableObject {
    enum Action {
        case loadData
        case didTapPurchaseButton
    }
    struct State {
        var purchaseItems: [PurchaseSelectedItemViewModel]?
    }
    @Published private(set) var state = State()
    private(set) var showPaymentViewController = PassthroughSubject<Void, Never>()
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            Task { await loadData() }
        case .didTapPurchaseButton:
            Task { await didTapPurchaseButton() }
        }
    }
}

extension PurchaseViewModel {
    @MainActor
    private func loadData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.state.purchaseItems = [
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "아이엠판다 펀치리버스\n스포츠스트랩 38/40mm, 애플워치 SE", description: "수량 2개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation3", description: "수량 3개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation4", description: "수량 4개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation5", description: "수량 5개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation6", description: "수량 6개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation7", description: "수량 7개 / 무료배송")
            ]
        }
    }
    
    @MainActor
    private func didTapPurchaseButton() async {
        showPaymentViewController.send()
    }
}
