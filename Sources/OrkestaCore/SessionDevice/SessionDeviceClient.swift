//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 09/04/24.
//

import Foundation
import JavaScriptCore
import WebKit

public class SessionDeviceClient: NSObject, WKScriptMessageHandler {
    
    public weak var delegate: DeviceSessionDelegate?
    public var successSession: ((String) -> ())?
    public var failureSession: ((String) -> ())?
    public var getSessionListener = false
    
    // MARK: - Internal Properties
    
    private let coreConfig: CoreConfig
    
    // MARK: - Public Initializer
    
    var webView: WKWebView?

    public init(coreConfig: CoreConfig) {
        self.coreConfig = coreConfig
    }
    
    public func getSessionDeviceId(_ successSessionID: @escaping (String) -> Void, _ failureSessionID: @escaping (String) -> Void) {
        getSessionListener = false
        successSession = successSessionID
        failureSession = failureSessionID
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "postMessageListener")
        webView = WKWebView(frame: .zero, configuration: config)
        
        let path = "/script/device-session.html?merchant_id=\(coreConfig.merchantId)&public_key=\(coreConfig.publicKey)"
        let url = coreConfig.environment.resourcesBaseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!
        webView?.load(URLRequest(url: URL(string: url)!))
        
        Timer.scheduledTimer(withTimeInterval: 12.0, repeats: false) { timer in
            if !self.getSessionListener {
                self.webView?.load(URLRequest(url: URL(string: url)!))
            }
        }
        
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
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
        
        //self.notifySuccess(for: formValues["device_session_id"]! as! String)
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("enterrrr")
        
        
        
        /*if !webView.isLoading {
            print("ent")
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                print("Timer fired!")
                webView.evaluateJavaScript("document.getElementById(\"app\").getElementsByTagName(\"span\")[0].innerText"){ (result, error) in
                    if let result = result {
                        print(result)
                        timer.invalidate()
                    }
                }
            }
            
        }*/
    }
    
    private func notifySuccess(for result: String) {
        delegate?.sessionDevice(self, didFinishWithResult: result)
    }
}
