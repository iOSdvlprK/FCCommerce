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
        var isError: String?
        var isLoading: Bool = false
        var banners: DetailBannerViewModel?
        var rate: DetailRateViewModel?
        var title: String?
        var option: DetailOptionViewModel?
        var price: DetailPriceViewModel?
        var mainImageUrls: [String]?
        var more: DetailMoreViewModel?
        var purchase: DetailPurchaseViewModel?
    }
    enum Action {
        case loadData
        case loading(Bool)
        case getDataSuccess(ProductDetailResponse)
        case getDataFailure(Error)
        case didTapChangeOption
        case didTapMore
        case didTapFavorite
        case didTapPurchase
    }
    @Published private(set) var state = State()
    private(set) var showOptionViewController = PassthroughSubject<Void, Never>()
    private var loadDataTask: Task<Void, Never>?
    private var isFavorite: Bool = false
    private var needShowMore: Bool = true
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            loadData()
        case let .getDataSuccess(response):
            Task { await transformProductDetailResponse(response) }
        case let .getDataFailure(error):
            Task { await getDataFailure(error) }
        case let .loading(isLoading):
            Task { await toggleLoading(isLoading) }
        case .didTapChangeOption:
            showOptionViewController.send()
        case .didTapMore:
            Task { await toggleMore() }
        case .didTapFavorite:
            Task { await toggleFavorite() }
        case .didTapPurchase:
            break
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
    
    @MainActor
    private func toggleLoading(_ isLoading: Bool) async {
        state.isLoading = isLoading
    }
    
    @MainActor
    private func toggleFavorite() async {
        isFavorite.toggle()
        state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
    }
    
    @MainActor
    private func toggleMore() async {
        needShowMore = false
        state.more = needShowMore ? DetailMoreViewModel() : nil
    }
    
    @MainActor
    private func transformProductDetailResponse(_ response: ProductDetailResponse) async {
        state.isError = nil
        state.banners = DetailBannerViewModel(imageUrls: response.bannerImages)
        state.rate = DetailRateViewModel(rate: response.product.rate)
        state.title = response.product.name
        state.option = DetailOptionViewModel(type: response.option.type, name: response.option.name, imageUrl: response.option.image)
        state.price = DetailPriceViewModel(discountRate: "\(response.product.discountPercent)", originPrice: response.product.originalPrice.moneyString, currentPrice: response.product.discountPrice.moneyString, shippingType: "무료배송")
        state.mainImageUrls = response.detailImages
        state.more = needShowMore ? DetailMoreViewModel() : nil
        state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
    }
    
    @MainActor
    private func getDataFailure(_ error: Error) {
        state.isError = "에러가 발생했습니다. \(error.localizedDescription)"
    }
}
