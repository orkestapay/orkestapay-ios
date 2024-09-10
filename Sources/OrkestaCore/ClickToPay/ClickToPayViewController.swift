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
    private var completed: ([String: Any]) -> Void
    private var error: ([String: Any]) -> Void
    private var cancel: () -> Void

    
    init(_ completed: @escaping ([String: Any]) -> Void, _ error: @escaping ([String: Any]) -> Void, _ cancel: @escaping () -> Void) {
        self.completed = completed
        self.error = error
        self.cancel = cancel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor.white
        //self.showLoader()
    }
    

    func loadCheckout() {
        /*let userScript = WKUserScript(
            source: scriptSource,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )*/

        //self.configuration.preferences.javaScriptEnabled = true
        self.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //self.configuration.userContentController.addUserScript(userScript)
        self.configuration.userContentController.add(self, name: "postMessageListener")
        self.webView = WKWebView(
            frame: view.bounds,
            configuration: self.configuration
        )

        self.webView!.navigationDelegate = self
        self.webView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let url = URL(string: "https://checkout.dev.orkestapay.com/integrations/click2pay/#/checkout/mch_205991e69bef45949c7dadb3519b1ae8/pk_test_grd7q3jrzb0yqih6pj6z3cznsl7c5ngb/dd1cbff5-dc54-4665-a449-554d20b61c0a_dpa0/en_US?dpaName=Testdpa0&cardBrands=amex&cardBrands=mastercard&cardBrands=visa&email=orkestapay.customer.02@yopmail.com&phoneCountryCode=52&phoneNumber=7712345678&firstName=John&lastName=Doe&isSandbox=false") {
            let request = URLRequest(url: url)
            self.webView?.load(request)
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
            
        self.modalPresentationStyle = .pageSheet
        self.presentationController?.delegate = self
        viewController.rootViewController?.present(self, animated: true, completion: nil)
            
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
                completed(data)
            case .ERROR:
                guard let data = jsonObject["error"] as? [String: Any] else {
                    return
                }
                error(data)
            case .CANCEL:
                cancel()
                close()
            }

        }
                
    }
    
    func close() {
        dismiss(animated: true)
    }
}
