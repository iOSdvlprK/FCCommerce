//
//  DetailRootView.swift
//  FCCommerce
//
//  Created by joe on 9/26/26.
//

import SwiftUI
import Kingfisher

struct DetailRootView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    if let bannersViewModel = viewModel.state.banners {
                        DetailBannerView(viewModel: bannersViewModel)
                            .padding(.bottom, 15)
                    }
                    if let rateViewModel = viewModel.state.rate {
                        HStack(spacing: 0) {
                            Spacer()
                            DetailRateView(viewModel: rateViewModel)
                        }
                        .padding(.horizontal, 20)
                    }
                    if let titleViewModel = viewModel.state.title {
                        HStack(spacing: 0) {
                            Text(titleViewModel)
                                .font(CPFont.SwiftUI.m17)
                                .foregroundStyle(CPColor.SwiftUI.bk)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    if let optionViewModel = viewModel.state.option {
                        Group {
                            DetailOptionView(viewModel: optionViewModel)
                                .padding(.bottom, 32)
                            HStack(spacing: 0) {
                                Spacer()
                                Text("옵션 선택하기")
                                    .font(CPFont.SwiftUI.m12)
                                    .foregroundStyle(CPColor.SwiftUI.keyColorBlue)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    if let priceViewModel = viewModel.state.price {
                        HStack(spacing: 0) {
                            DetailPriceView(viewModel: priceViewModel)
                            Spacer()
                        }
                        .padding(.bottom, 32)
                        .padding(.horizontal, 20)
                    }
                    if let mainImageViewModel = viewModel.state.mainImageUrls {
                        LazyVStack(spacing: 0) {
                            ForEach(mainImageViewModel, id: \.self) {
                                KFImage.url(URL(string: $0))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .padding(.bottom, 32)
                        .clipped()
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
