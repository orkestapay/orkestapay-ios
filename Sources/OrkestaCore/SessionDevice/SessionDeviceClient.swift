//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 09/04/24.
//

import Foundation
import JavaScriptCore
import WebKit

public class DeviceSessionClient: NSObject, WKScriptMessageHandler {
    
    public weak var delegate: DeviceSessionDelegate?
    public var successSession: ((String) -> ())?
    
    // MARK: - Internal Properties
    
    private let coreConfig: CoreConfig
    
    // MARK: - Public Initializer
    
    var webView: WKWebView?

    public init(coreConfig: CoreConfig) {
       
        self.coreConfig = coreConfig
        
    }
    
    public func getSessionId(successSessionID: @escaping (String) -> Void) {
        successSession = successSessionID
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "postMessageListener")
        webView = WKWebView(frame: .zero, configuration: config)
        
        let path = "/script/device-session.html?merchant_id=\(coreConfig.merchantId)&public_key=\(coreConfig.publicKey)"
        let url = coreConfig.environment.resourcesBaseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!
        webView?.load(URLRequest(url: URL(string: url)!))
        
    }
    
    public func getSessionIdJS(completion: @escaping (String?) -> Void) {
        print("entttr")


        
        let context = JSContext()!
        context.exceptionHandler = { context, exception in
            Swift.print("exception:", exception?.toString() ?? "")
        }
        let script = try! String(contentsOf: URL(string: "https://checkout.dev.orkestapay.com/script/orkestapay.js")!)
        print(script)
        context.evaluateScript(script)
        
    

        //let merchantId = "mch_1a06356c660d4552b0d873b43d227071"
        //let publicKey = "pk_test_vlvzqfkkycg4tpw9p340g63hc5zmwbbg"
        
        //let merchantId = "dh_merchant_id" as NSString
        //let publicKey = "dh_public_key" as NSString
        
        
        //context.setObject(coreConfig.merchantId, forKeyedSubscript: merchantId)
        //context.setObject(coreConfig.publicKey, forKeyedSubscript: publicKey)
        
        /*print("initOrkestaPay({merchant_id: '\(coreConfig.merchantId)', public_key:'\(coreConfig.publicKey)'})")
        
        let orkestapay = context.evaluateScript("initOrkestaPay({merchant_id: '\(coreConfig.merchantId)', public_key:'\(coreConfig.publicKey)'})")
        print(orkestapay?.toString())*/
        
        /*let testFunction = context.objectForKeyedSubscript("orkestapay")
        print(testFunction)
        
        Task {
            do {
                var data = try await context.callAsyncFunction(key: "orkestapay.getDeviceInfo")
                print(data)
                return data.toString()
                
            }
            catch {
                print(error.localizedDescription) // Prints: Key is empty
                return nil
            }
            
        }*/
        
        //let deviceInfo = context.evaluateScript("(async function () { const deviceInfo = await orkestapay.getDeviceInfo();})();")
        //print(deviceInfo!)
 
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "postMessageListener" {
            guard let formValues = message.body as? [String: AnyObject] else { return }
            print(formValues["device_session_id"]!)
            successSession!(formValues["device_session_id"]! as! String)
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
        delegate?.deviceSession(self, didFinishWithResult: result)
    }
}
