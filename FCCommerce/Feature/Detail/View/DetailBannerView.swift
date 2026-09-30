//
//  DetailBannerView.swift
//  FCCommerce
//
//  Created by joe on 9/27/26.
//

import SwiftUI
import Combine
import Kingfisher

final class DetailBannerViewModel: ObservableObject {
    @Published var imageUrls: [String]
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
    }
}

struct DetailBannerView: View {
    @ObservedObject var viewModel: DetailBannerViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.imageUrls, id: \.self) { imageUrl in
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)
    }
}

#Preview {
    DetailBannerView(viewModel: DetailBannerViewModel(imageUrls: [
        "https://picsum.photos/id/1/500/500",
        "https://picsum.photos/id/2/500/500",
        "https://picsum.photos/id/3/500/500",
        "https://picsum.photos/id/4/500/500"]))
}
