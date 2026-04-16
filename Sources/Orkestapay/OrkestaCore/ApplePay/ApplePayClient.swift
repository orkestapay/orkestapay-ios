//
//  ApplePayClient.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 10/10/24.
//

import Foundation
import UIKit
import PassKit

class ApplePayClient: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    private let coreConfig: CoreConfig
    private var paymentMethod2Registry:((PaymentMethod2RegistryApplePay) -> ())?
    private var onError: (([String: Any]) -> ())?
    private var onCancel: (() -> ())?
    
    init(coreConfig: CoreConfig) {
        self.coreConfig = coreConfig
    }
    
    public func applePayChechout(_ applePayRequest: ApplePayRequest, merchantIdentifier: String, paymentMethod2Registry: @escaping (PaymentMethod2RegistryApplePay) -> (), _ onError: @escaping ([String: Any]) -> Void, _ onCancel: @escaping () -> Void) {
        self.paymentMethod2Registry = paymentMethod2Registry
        self.onError = onError
        self.onCancel = onCancel
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.countryCode = applePayRequest.countryCode
        paymentRequest.currencyCode = applePayRequest.currencyCode
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
        paymentRequest.merchantCapabilities = [.credit, .debit, .threeDSecure]
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: applePayRequest.merchantName, amount: NSDecimalNumber(string: applePayRequest.totalAmount))
        ]
        guard let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
            return
        }
        
        guard let viewController = UIApplication.shared.firstKeyWindow else {
            return
        }
        
        paymentAuthorizationVC.delegate = self
        viewController.rootViewController?.present(paymentAuthorizationVC, animated: true)
    }

    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        onCancel!()
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: ((PKPaymentAuthorizationStatus) -> Void)) {
        controller.dismiss(animated: true, completion: nil)
        let token = payment.token
        let paymentData = token.paymentData
        do {
            let decoder = JSONDecoder()
            let dataDecoded = try decoder.decode(ApplePayPaymentTokenData.self, from: paymentData)
            let applePayTokenData = ApplePayTokenData(type: .APPLE_PAY, data: dataDecoded.data, header: dataDecoded.header, signature: dataDecoded.signature, version: dataDecoded.version)
            let paymentMethodApplePay = PaymentMethod2RegistryApplePay(type: .APPLE_PAY, customerId: nil, applePay: applePayTokenData)
            paymentMethod2Registry!(paymentMethodApplePay)
        } catch {
            onError!(["decode error": error.localizedDescription])
        }
        
    }
}
