//
//  PaymentViewController.swift
//  FCCommerce
//
//  Created by joe on 10/9/26.
//

import SwiftUI
import WebKit

final class PaymentViewController: UIViewController {
    private var webView = WKWebView()
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
    }
    
    private func loadWebView() {
        guard let htmlPath = Bundle.main.path(forResource: "test", ofType: "html") else { return }
        let url = URL(fileURLWithPath: htmlPath)
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

#Preview {
    PaymentViewController()
}
