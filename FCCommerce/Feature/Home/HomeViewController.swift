//
//  HomeViewController.swift
//  FCCommerce
//
//  Created by joe on 9/4/26.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private enum Section: Int {
        case banner
        case horizontalProductItem
        case couponButton
        case verticalProductItem
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var dataSource: DataSource = setDataSource()
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    private var viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = compositionalLayout
        bindingViewModel()
        
        viewModel.process(action: .loadData)
        viewModel.process(action: .loadCoupon)
    }
    
    private func setCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch self?.currentSection[section] {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProductItem:
                return HomeProductCollectionViewCell.horizontalProductItemLayout()
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductItemLayout()
            case .couponButton:
                return HomeCouponButtonCollectionViewCell.couponButtonItemLayout()
            case .none: return nil
            }
        }
    }
    
    private func bindingViewModel() {
        viewModel.state.$collectionViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }
            .store(in: &cancellables)
    }
    
    private func setDataSource() -> DataSource {
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            switch self?.currentSection[indexPath.section] {
            case .banner:
                return self?.bannerCell(collectionView, indexPath, itemIdentifier)
            case .horizontalProductItem, .verticalProductItem:
                return self?.productItemCell(collectionView, indexPath, itemIdentifier)
            case .couponButton:
                return self?.couponButtonCell(collectionView, indexPath, itemIdentifier)
            case .none:
                return .init()
            }
        })
    }
    
    private func applySnapShot() {
        var snapShot = SnapShot()
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels {
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels, toSection: .banner)
        }
        
        if let horizontalProductViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels {
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
        }
        
        if let couponViewModels = viewModel.state.collectionViewModels.couponState {
            snapShot.appendSections([.couponButton])
            snapShot.appendItems(couponViewModels, toSection: .couponButton)
        }
        
        if let verticalProductViewModels = viewModel.state.collectionViewModels.verticalProductViewModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
        dataSource.apply(snapShot)
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
    
    private func couponButtonCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = itemIdentifier as? HomeCouponButtonCollectionViewCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCouponButtonCollectionViewCell", for: indexPath) as? HomeCouponButtonCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
}
