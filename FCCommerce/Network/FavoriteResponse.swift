//
//  FavoriteResponse.swift
//  FCCommerce
//
//  Created by joe on 9/24/26.
//

import Foundation

struct FavoriteResponse: Decodable {
    let favorites: [Product]
}
