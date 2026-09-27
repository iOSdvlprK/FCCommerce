//
//  DetailRootView.swift
//  FCCommerce
//
//  Created by joe on 9/26/26.
//

import SwiftUI

struct DetailRootView: View {
    var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    if let banners = viewModel.state.banners {
                        DetailBannerView(viewModel: banners)
                    }
                }
            }
        }
        
        if viewModel.state.isLoading {
            Text("로딩 중...")
        } else {
            Text("로딩 완료!")
        }
        Text("Hello, World!")
            .onAppear {
                viewModel.process(.loadData)
            }
    }
}

#Preview {
    DetailRootView(viewModel: DetailViewModel())
}
