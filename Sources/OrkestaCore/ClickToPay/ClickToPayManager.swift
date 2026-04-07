//
//  ClickToPayManager.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 07/04/26.
//

import SafariServices

public class ClickToPayManager: NSObject {
    
    public static let shared = ClickToPayManager()
    private var safariVC: SFSafariViewController?
    
    private var coreConfig: CoreConfig?
    private var clickToPay: ClickToPay?
    private var onSuccess: ((PaymentMethodResponse) -> Void)?
    private var onError: ((String) -> Void)?
    private var onCancel: (() -> Void)?
    

    func startCheckout(
        _ coreConfig: CoreConfig, _ clickToPay: ClickToPay, _ onSuccess: @escaping (PaymentMethodResponse) -> Void, _ onError: @escaping (String) -> Void, _ onCancel: @escaping () -> Void
    ) {
        self.coreConfig = coreConfig
        self.clickToPay = clickToPay
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel

        guard let topController = getTopViewController() else {
            print("Error: No se encontró un ViewController para presentar el SDK")
            return
        }

        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        config.barCollapsingEnabled = true
        
        let queryParameters = addParams()
        
        let path = "/integrations/click-to-pay"
        
        let url = coreConfig.environment.resourcesBaseURL.appendingPathComponent(path)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "merchantId", value: coreConfig.merchantId), URLQueryItem(name: "publicKey", value: coreConfig.publicKey)] + queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let encodeParams = urlComponents?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        urlComponents?.percentEncodedQuery = encodeParams
        
        if let url = urlComponents?.url {
            print(url)
            
            let controllerInstance = SFSafariViewController(url: url,configuration: config)
            controllerInstance.delegate = self
            self.safariVC = controllerInstance
            controllerInstance.dismissButtonStyle = .cancel
            topController.present(controllerInstance, animated: true)
        }
    }
    
    public func handleOpenURL(_ url: URL) {
        guard url.scheme == "orkestapay-c2p" else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        let status = components.queryItems?.first(where: { $0.name == "status" })?.value ?? "CANCEL"
        guard let event = ClickToPayEvent(rawValue: status) else {
            return
        }

        safariVC?.dismiss(animated: true) { [weak self] in
            
            switch event {
            case .COMPLETE:
                let paymentMethodId = components.queryItems?.first(where: { $0.name == "payment_method_id" })?.value ?? ""
                let type = PaymentMethodType(rawValue: components.queryItems?.first(where: { $0.name == "type" })?.value ?? "CLICK_TO_PAY") ?? PaymentMethodType.CLICK_TO_PAY
                
                let bin = components.queryItems?.first(where: { $0.name == "bin" })?.value ?? ""
                let lastFour = components.queryItems?.first(where: { $0.name == "last_four" })?.value ?? ""
                let brand = components.queryItems?.first(where: { $0.name == "brand" })?.value ?? ""
                let cardType = CardType(rawValue: components.queryItems?.first(where: { $0.name == "card_type" })?.value ?? "UNKNOWN") ?? CardType.UNKNOWN
                let holderName = components.queryItems?.first(where: { $0.name == "holder_name" })?.value ?? ""
                let expirationMonth = components.queryItems?.first(where: { $0.name == "expiration_month" })?.value ?? ""
                let expirationYear = components.queryItems?.first(where: { $0.name == "expiration_year" })?.value ?? ""
                let oneTimeUse = components.queryItems?.first(where: { $0.name == "one_time_use" })?.value ?? ""
                let card = CardResponse(bin: bin, lastFour: lastFour, brand: brand, cardType: cardType, expirationMonth: expirationMonth, expirationYear: expirationYear, holderName: holderName, holderLastName: nil, oneTimeUse: oneTimeUse.toBool)
                
                let paymentMethod = PaymentMethodResponse(paymentMethodId: paymentMethodId, alias: nil, type: type, card: card, paymentOption: nil)
                self?.onSuccess?(paymentMethod)
            case .ERROR:
                let message = components.queryItems?.first(where: { $0.name == "message" })?.value ?? ""
                self?.onError?(message)
            case .CANCEL:
                self?.onCancel?()
            }
            
            self?.safariVC = nil
        }
    }


    private func getTopViewController(base: UIViewController? = UIApplication.shared.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getTopViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
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
}

// MARK: - SFSafariViewControllerDelegate
extension ClickToPayManager: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("onCancellll")
        safariVC = nil
        onCancel?()
    }
}


extension String {
    var toBool: Bool {
        return (self as NSString).boolValue
    }
}
