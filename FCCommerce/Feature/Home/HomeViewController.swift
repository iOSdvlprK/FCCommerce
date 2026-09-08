//
//  HomeViewController.swift
//  FCCommerce
//
//  Created by joe on 9/4/26.
//

import UIKit

class HomeViewController: UIViewController {
    enum Section {
        case banner
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>?
    private var compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(165.0 / 393.0))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = compositionalLayout
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
            cell.setImage(itemIdentifier)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapShot.appendSections([.banner])
        snapShot.appendItems([UIImage(resource: .slide1), UIImage(resource: .slide2), UIImage(resource: .slide3)], toSection: .banner)
        dataSource?.apply(snapShot)
    }
}
