//
//  FavoriteViewModel.swift
//  FCCommerce
//
//  Created by joe on 9/23/26.
//

import Foundation
import Combine

final class FavoriteViewModel {
    enum Action {
        case getFavoriteFromAPI
        case getFavoriteSuccess(FavoriteResponse)
        case getFavoriteFailure(Error)
        case didTapPurchaseButton
    }
    final class State {
        @Published var tableViewModel: [FavoriteItemTableViewCellViewModel]?
    }
    private(set) var state = State()
    private var loadDataTask: Task<Void, Never>?
    
    func process(_ action: Action) {
        switch action {
        case .getFavoriteFromAPI:
            getFavoriteFromAPI()
        case .getFavoriteSuccess(let favoriteResponse):
            translateFavoriteItemViewModel(favoriteResponse)
        case .getFavoriteFailure(let error):
            print(error)
        case .didTapPurchaseButton:
            break
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
}

extension FavoriteViewModel {
    private func getFavoriteFromAPI() {
        loadDataTask = Task {
            do {
                let response = try await NetworkService.shared.getFavoriteData()
                process(.getFavoriteSuccess(response))
            } catch {
                process(.getFavoriteFailure(error))
            }
        }
    }
    
    private func translateFavoriteItemViewModel(_ response: FavoriteResponse) {
        state.tableViewModel = response.favorites.map {
            FavoriteItemTableViewCellViewModel(imageUrl: $0.imageUrl, productName: $0.title, productPrice: $0.discountPrice.moneyString)
        }
    }
}
