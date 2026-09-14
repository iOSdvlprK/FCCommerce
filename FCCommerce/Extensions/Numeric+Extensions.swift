//
//  Numeric+Extensions.swift
//  FCCommerce
//
//  Created by joe on 9/14/26.
//

import Foundation

extension Numeric {
    var moneyString: String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return (formatter.string(for: self) ?? "") + "원"
    }
}
