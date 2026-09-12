//
//  HomeViewModel.swift
//  FCCommerce
//
//  Created by joe on 9/12/26.
//

import Foundation
import Combine

class HomeViewModel {
    @Published var bannerViewModels: [HomeBannerCollectionViewCellViewModel]?
    @Published var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
    @Published var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
    
    private var loadDataTask: Task<Void, Never>?
    
    func loadData() {
        loadDataTask = Task {
            do {
                let response = try await NetworkService.shared.getHomeData()
                Task { await transformBanner(response) }
                Task { await transformHorizontalProduct(response) }
                Task { await transformVerticalProduct(response) }
            } catch {
                print("network error: \(error)")
            }
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
    
    @MainActor
    private func transformBanner(_ response: HomeResponse) async {
        bannerViewModels = response.banners.map { bannerResponse in
            HomeBannerCollectionViewCellViewModel(bannerImageUrl: bannerResponse.imageUrl)
        }
    }
    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        horizontalProductViewModels = response.horizontalProducts.map {
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl, title: $0.title, reasonDiscountString: $0.discount, originalPrice: "\($0.originalPrice)", discountPrice: "\($0.discountPrice)")
        }
    }
    
    @MainActor
    private func transformVerticalProduct(_ response: HomeResponse) async {
        verticalProductViewModels = response.verticalProducts.map {
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl, title: $0.title, reasonDiscountString: $0.discount, originalPrice: "\($0.originalPrice)", discountPrice: "\($0.discountPrice)")
        }
    }
}
