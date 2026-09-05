//
//  HomeBannerCollectionViewCell.swift
//  FCCommerce
//
//  Created by joe on 9/5/26.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
