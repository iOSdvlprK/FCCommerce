//
//  Product.swift
//  FCCommerce
//
//  Created by joe on 9/24/26.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
    let discount: String
    let originalPrice: Int
    let discountPrice: Int
}
