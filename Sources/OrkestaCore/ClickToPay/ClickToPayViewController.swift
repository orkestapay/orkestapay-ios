//
//  ClickToPayViewController.swift
//  
//
//  Created by Hector Rodriguez on 05/09/24.
//

import Foundation
import WebKit
import UIKit

class ClickToPayViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIAdaptivePresentationControllerDelegate, WKScriptMessageHandler {
    public var webView: WKWebView?
    let configuration = WKWebViewConfiguration()
    private var activityIndicator: UIActivityIndicatorView!
    private let coreConfig: CoreConfig
    private var clickToPay: ClickToPay?
    private var onSuccess: (PaymentMethodResponse) -> Void
    private var onError: ([String: Any]) -> Void
    private var onCancel: () -> Void
    
    private var successPaymentMethod = false

    
    init(_ coreConfig: CoreConfig, _ clickToPay: ClickToPay, _ onSuccess: @escaping (PaymentMethodResponse) -> Void, _ onError: @escaping ([String: Any]) -> Void, _ onCancel: @escaping () -> Void) {
        self.clickToPay = clickToPay
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel
        self.coreConfig = coreConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        //self.showLoader()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent && !successPaymentMethod {
            onCancel()
        }
    }
    
    

    func loadCheckout() {
        self.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        self.configuration.userContentController.add(self, name: "postMessageListener")
        self.webView?.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.webView = WKWebView(
            frame: view.bounds,
            configuration: self.configuration
        )

        self.webView!.navigationDelegate = self
        self.webView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let queryParameters = addParams()
        
        let path = "/integrations/click2pay/#/checkout/\(coreConfig.merchantId)/\(coreConfig.publicKey)"
        let url = coreConfig.environment.resourcesBaseURL.appendingPathComponent(path)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let encodeParams = urlComponents?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        urlComponents?.percentEncodedQuery = encodeParams

        if let range = urlComponents!.url!.absoluteString.range(of:"%23") {
            self.webView?.load(URLRequest(url: URL(string: urlComponents!.url!.absoluteString.replacingCharacters(in: range, with:"#") )!))
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            view.addSubview(webView)

            webView.frame.size.height = view.frame.height
            view.translatesAutoresizingMaskIntoConstraints = false
            webView.scrollView.isScrollEnabled = true

            //self.hideLoader()
    }
    
    func showWebView() -> Bool {
        guard let viewController = UIApplication.shared.firstKeyWindow else {
            return false
        }
        if(coreConfig.merchantId == "") {
            onError(["config error": "merchant id is empty"])
            return false
        }
        if(coreConfig.publicKey == ""){
            onError(["config error": "public key is empty"])
            return false
        }
            
        self.presentationController?.delegate = self
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), let navigationController = keyWindow.rootViewController as?
            UINavigationController {
            navigationController.pushViewController(self, animated: true)
        } else {
            self.modalPresentationStyle = .pageSheet
            viewController.rootViewController?.present(self, animated: true, completion: nil)
        }
        
        return true
    }
    
    private func showLoader() {
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.color = .blue
        self.activityIndicator.center = view.center
        view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        self.activityIndicator.removeFromSuperview()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "postMessageListener" {
            guard let jsonObject = message.body as? [String: AnyObject] else { return }
            guard let status = jsonObject["status"] as? String else {
                return
            }
            
            guard let event = ClickToPayEvent(rawValue: status) else {
                return
            }
            
            switch event {
            case .COMPLETE:
                guard let data = jsonObject["data"] as? [String: Any] else {
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let paymentMethod = try decoder.decode(PaymentMethodResponse.self, from: json)
                    onSuccess(paymentMethod)
                    successPaymentMethod = true
                    close()
                } catch {
                    onError(["decode error": error.localizedDescription])
                }
            case .ERROR:
                guard let data = jsonObject["error"] as? [String: Any] else {
                    return
                }
                onError(data)
            case .CANCEL:
                onCancel()
                close()
            }

        }
                
    }
    
    func addParams() -> [String: String] {
        let mirrored_object = Mirror(reflecting: self.clickToPay!)
        var queryParameters: [String: String] = [:]
        for (label, value) in mirrored_object.children {
            
            guard let label = label else { continue }
            
            if let description = value as? String {
                queryParameters[label] = description
            } else if let description = value as? Bool {
                queryParameters[label] = String(description)
            }
        }
        return queryParameters
        
    }
    
    func close() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    
}
