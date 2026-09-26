//
//  DetailViewModel.swift
//  FCCommerce
//
//  Created by joe on 9/26/26.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    struct State {
        var isLoading: Bool = false
    }
    enum Action {
        case loadData
        case loading(Bool)
        case getDataSuccess(ProductDetailResponse)
        case getDataFailure(Error)
    }
    @Published private(set) var state = State()
    private var loadDataTask: Task<Void, Never>?
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            loadData()
        case let .getDataSuccess(response):
            print(response)
        case let .getDataFailure(error):
            print(error)
        case let .loading(isLoading):
            state.isLoading = isLoading
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
}

extension DetailViewModel {
    private func loadData() {
        loadDataTask = Task {
            defer {
                process(.loading(false))
            }
            do {
                process(.loading(true))
                let response = try await NetworkService.shared.getProductDetailData()
                process(.getDataSuccess(response))
            } catch {
                process(.getDataFailure(error))
            }
        }
    }
}
