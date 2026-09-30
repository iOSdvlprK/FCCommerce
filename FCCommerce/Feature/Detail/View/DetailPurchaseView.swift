//
//  DetailPurchaseView.swift
//  FCCommerce
//
//  Created by joe on 9/30/26.
//

import SwiftUI
import Combine

final class DetailPurchaseViewModel: ObservableObject {
    @Published var isFavorite: Bool
    
    init(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

struct DetailPurchaseView: View {
    @ObservedObject var viewModel: DetailPurchaseViewModel
    var onFavoriteTapped: () -> Void
    var onPurchaseTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 30) {
            Button(action: onFavoriteTapped) {
                viewModel.isFavorite ? CPImage.SwiftUI.favoriteOn : CPImage.SwiftUI.favoriteOff
            }
            Button(action: onPurchaseTapped) {
                Text("구매하기")
                    .font(CPFont.SwiftUI.m16)
                    .foregroundStyle(CPColor.SwiftUI.wh)
            }
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .background(CPColor.SwiftUI.keyColorBlue)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    DetailPurchaseView(viewModel: DetailPurchaseViewModel(isFavorite: true), onFavoriteTapped: {}, onPurchaseTapped: {})
}
