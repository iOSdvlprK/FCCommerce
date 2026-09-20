//
//  HomeSeparateLineCollectionViewCell.swift
//  FCCommerce
//
//  Created by joe on 9/19/26.
//

import UIKit

struct HomeSeparateLineCollectionViewCellViewModel: Hashable {
}

final class HomeSeparateLineCollectionViewCell: UICollectionViewCell {
    static let reuseableId = "HomeSeparateLineCollectionViewCell"
    
    func setViewModel(_ viewModel: HomeSeparateLineCollectionViewCellViewModel) {
        contentView.backgroundColor = CPColor.gray1
    }
}

extension HomeSeparateLineCollectionViewCell {
    static func separateLineLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(11))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}
