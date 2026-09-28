//
//  DetailOptionView.swift
//  FCCommerce
//
//  Created by joe on 9/28/26.
//

import SwiftUI
import Combine
import Kingfisher

final class DetailOptionViewModel: ObservableObject {
    @Published var type: String
    @Published var name: String
    @Published var imageUrl: String
    
    init(type: String, name: String, imageUrl: String) {
        self.type = type
        self.name = name
        self.imageUrl = imageUrl
    }
}

struct DetailOptionView: View {
    var viewModel: DetailOptionViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.type)
                    .foregroundStyle(CPColor.SwiftUI.gray5)
                    .font(CPFont.SwiftUI.r12)
                Text(viewModel.name)
                    .foregroundStyle(CPColor.SwiftUI.bk)
                    .font(CPFont.SwiftUI.b14)
            }
            Spacer()
            KFImage(URL(string: viewModel.imageUrl))
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    DetailOptionView(viewModel: DetailOptionViewModel(type: "색상", name: "코랄", imageUrl: "https://picsum.photos/id/1/500/500"))
}
