//
//  OptionRootView.swift
//  FCCommerce
//
//  Created by joe on 10/2/26.
//

import SwiftUI

struct OptionRootView: View {
    @ObservedObject var viewModel: OptionViewModel
    
    var body: some View {
        Text("옵션 화면!!")
    }
}

#Preview {
    OptionRootView(viewModel: OptionViewModel())
}
