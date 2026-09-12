//
//  HomeViewController.swift
//  FCCommerce
//
//  Created by joe on 9/4/26.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    enum Section: Int {
        case banner
        case horizontalProductItem
        case verticalProductItem
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    private var viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = compositionalLayout
        bindingViewModel()
        viewModel.loadData()
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
    
    private func bindingViewModel() {
        viewModel.$bannerViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }
            .store(in: &cancellables)
        viewModel.$horizontalProductViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }
            .store(in: &cancellables)
        viewModel.$verticalProductViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }
            .store(in: &cancellables)
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
    
    private func applySnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        if let bannerViewModels = viewModel.bannerViewModels {
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels, toSection: .banner)
        }
        
        if let horizontalProductViewModels = viewModel.horizontalProductViewModels {
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
        }
        
        if let verticalProductViewModels = viewModel.verticalProductViewModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
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
