//
//  HomeViewController.swift
//  FCCommerce
//
//  Created by joe on 9/4/26.
//

import UIKit

class HomeViewController: UIViewController {
    enum Section: Int {
        case banner
        case horizontalProductItem
        case verticalProductItem
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = compositionalLayout
        loadData()
        setDataSource()
    }
    
    private static func setCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { section, _ in
            switch Section(rawValue: section) {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProductItem:
                return HomeProductCollectionViewCell.horizontalProductItemLayout()
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductItemLayout()
            case .none: return nil
            }
        }
    }
    
    private func loadData() {
        Task {
            do {
                let response = try await NetworkService.shared.getHomeData()
                let bannerViewModels = response.banners.map { bannerResponse in
                    HomeBannerCollectionViewCellViewModel(bannerImageUrl: bannerResponse.imageUrl)
                }
                let horizontalProductViewModels = response.horizontalProducts.map {
                    HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl, title: $0.title, reasonDiscountString: $0.discount, originalPrice: "\($0.originalPrice)", discountPrice: "\($0.discountPrice)")
                }
                let verticalProductViewModels = response.verticalProducts.map {
                    HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl, title: $0.title, reasonDiscountString: $0.discount, originalPrice: "\($0.originalPrice)", discountPrice: "\($0.discountPrice)")
                }
                applySnapShot(bannerViewModels: bannerViewModels, horizontalProductViewModels: horizontalProductViewModels, verticalProductViewModels: verticalProductViewModels)
            } catch {
                print("network error: \(error)")
            }
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            switch Section(rawValue: indexPath.section) {
            case .banner:
                return self?.bannerCell(collectionView, indexPath, itemIdentifier)
            case .horizontalProductItem, .verticalProductItem:
                return self?.productItemCell(collectionView, indexPath, itemIdentifier)
            case .none:
                return .init()
            }
        })
    }
    
    private func applySnapShot(bannerViewModels: [HomeBannerCollectionViewCellViewModel], horizontalProductViewModels: [HomeProductCollectionViewCellViewModel], verticalProductViewModels: [HomeProductCollectionViewCellViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapShot.appendSections([.banner])
        snapShot.appendItems(bannerViewModels, toSection: .banner)
        
        snapShot.appendSections([.horizontalProductItem])
        snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
        
        snapShot.appendSections([.verticalProductItem])
        snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        dataSource?.apply(snapShot)
    }
    
    private func bannerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeBannerCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func productItemCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeProductCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCollectionViewCell", for: indexPath) as? HomeProductCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
}
