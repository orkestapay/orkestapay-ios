//
//  SessionDeviceClient.swift
//  
//
//  Created by Hector Rodriguez on 09/04/24.
//

import Foundation
import WebKit

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
    
    func getDeviceSessionId(_ successSessionID: @escaping (String) -> Void, _ failureSessionID: @escaping (String) -> Void) {
        getSessionListener = false
        successSession = successSessionID
        failureSession = failureSessionID
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "postMessageListener")
        webView = WKWebView(frame: .zero, configuration: config)
        
        let queryParameters: [String: String] = ["merchant_id": coreConfig.merchantId, "public_key": coreConfig.publicKey]
        
        let path = "/script/device-session.html"
        let urlString = coreConfig.environment.resourcesBaseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: urlString, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.webView?.load(URLRequest(url: urlComponents!.url!))
        }
        
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { timer in
            if !self.getSessionListener {
                self.webView?.load(URLRequest(url: urlComponents!.url!))
            }
        }
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "postMessageListener" {
            getSessionListener = true
            guard let formValues = message.body as? [String: AnyObject] else { return }
            let hasId = formValues.contains { (key: String, value: AnyObject) in
                return key == "device_session_id"
            }
            if hasId {
                successSession!(formValues["device_session_id"]! as! String)
            } else {
                failureSession!("Error getting device session id")
            }
            
        }
                
    }

}
