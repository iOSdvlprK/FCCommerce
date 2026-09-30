//
//  DetailRateView.swift
//  FCCommerce
//
//  Created by joe on 9/28/26.
//

import SwiftUI
import Combine

final class DetailRateViewModel: ObservableObject {
    @Published var rate: Int
    
    init(rate: Int) {
        self.rate = rate
    }
}

struct DetailRateView: View {
    @ObservedObject var viewModel: DetailRateViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.rate, id: \.self) { _ in
                starImage
                    .foregroundStyle(CPColor.SwiftUI.yellow)
            }
            ForEach(0..<(5 - viewModel.rate), id: \.self) { _ in
                starImage
                    .foregroundStyle(CPColor.SwiftUI.gray2)
            }
        }
    }
    
    var starImage: some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 16, height: 16)
    }
}

#Preview {
    DetailRateView(viewModel: DetailRateViewModel(rate: 4))
}
