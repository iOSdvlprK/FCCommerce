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
    private let getMessageScriptName = "receiveMessage"
    private let getPaymentCompleteScriptName = "paymentComplete"
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: getMessageScriptName)
        contentController.add(self, name: getPaymentCompleteScriptName)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        setUserAgent()
        
        let button = UIButton(frame: CGRect(x: 0, y: 400, width: 100, height: 100))
        button.setTitle("call javaScript", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.callJavaScript()
        }), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func loadWebView() {
        guard let htmlPath = Bundle.main.path(forResource: "test", ofType: "html") else { return }
        let url = URL(fileURLWithPath: htmlPath)
        var request = URLRequest(url: url)
        request.addValue("customValue", forHTTPHeaderField: "Header-Name")
        
        webView.load(request)
    }
    
    private func setUserAgent() {
        webView.customUserAgent = "Mozilla/5.0 (Linux; Android 10; SM-G960F Build/RKQ1.200823.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/74.0.3729.15 Mobile Safari/537.36"
    }
    
    private func setCookie() {
        guard let cookie = HTTPCookie(properties: [
            .domain: "google.co.kr",
            .path: "/",
            .name: "myCookie",
            .value: "value",
            .secure: false,
            .expires: NSDate(timeIntervalSince1970: 3600)
        ]) else { return }
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    }
    
    private func callJavaScript() {
        webView.evaluateJavaScript("javascriptFunction();")
    }
}

extension PaymentViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == getMessageScriptName {
//            viewModel.process(action: .getMessage)
        } else if message.name == getPaymentCompleteScriptName {
//            viewModel.process(action: .completePayment)
        }
    }
}

#Preview {
    PaymentViewController()
}
