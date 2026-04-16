//
//  SessionDeviceClient.swift
//  
//
//  Created by Hector Rodriguez on 09/04/24.
//

import Foundation
import WebKit
import UIKit

class DeviceSessionClient: NSObject, WKScriptMessageHandler {
    
    // MARK: - Internal Properties
    
    private let coreConfig: CoreConfig
    
    var successSession: ((String) -> ())?
    var failureSession: ((String) -> ())?
    private var getSessionListener = false
    
    // MARK: - Public Initializer
    
    var webView: WKWebView?

    init(coreConfig: CoreConfig) {
        self.coreConfig = coreConfig
    }
    
    func getDeviceSessionId(_ viewController: UIViewController, _ successSessionID: @escaping (String) -> Void, _ failureSessionID: @escaping (String) -> Void) {
        getSessionListener = false
        successSession = successSessionID
        failureSession = failureSessionID
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "postMessageListener")
        webView = WKWebView(frame: .zero, configuration: config)
        viewController.view.addSubview(webView!)
        
        let queryParameters: [String: String] = ["merchant_id": coreConfig.merchantId, "public_key": coreConfig.publicKey]
        
        let path = "/script/device-session"
        let urlString = coreConfig.environment.resourcesBaseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: urlString, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        /*URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0

        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }*/

        webView?.load(URLRequest(url: urlComponents!.url!))
        
        /*Timer.scheduledTimer(withTimeInterval: 12.0, repeats: false) { timer in
            if !self.getSessionListener {
                self.webView?.reload()
            }
        }*/
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "postMessageListener" {
            if !getSessionListener {
                guard let formValues = message.body as? [String: AnyObject] else { return }
                let hasId = formValues.contains { (key: String, value: AnyObject) in
                    return key == "device_session_id" 
                }
                let hasError = formValues.contains { (key: String, value: AnyObject) in
                    return key == "error"
                }
                if hasId {
                    successSession!(formValues["device_session_id"]! as! String)
                } else if hasError {
                    failureSession!(formValues["error"]!["message"]! as! String)
                } else {
                    failureSession!("Error getting device session id")
                }
                getSessionListener = true
            }
        }
                
    }

}
