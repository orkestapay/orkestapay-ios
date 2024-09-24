//
//  OrkestapayClient.swift
//
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation
import UIKit
#if canImport(OrkestaCore)
import OrkestaCore
#endif

public class OrkestapayClient: NSObject, UIAdaptivePresentationControllerDelegate {
    private let config: CoreConfig
    private let deviceSessionClient: DeviceSessionClient
    private let orkestapayAPI: OrkestapayAPI
    private var onCancel: () -> Void = { }
    
    public init(merchantId: String, publicKey:String, isProductionMode: Bool) {
        self.config = CoreConfig(merchantId: merchantId, publicKey: publicKey, environment: isProductionMode ? .production : .sandbox)
        self.deviceSessionClient = DeviceSessionClient(coreConfig: config)
        self.orkestapayAPI = OrkestapayAPI(coreConfig: config)
    }
    
    
    public func createDeviceSession(viewController: UIViewController, successSessionID: @escaping (String) -> (), failureSessionID: @escaping (String) -> ()) {
        deviceSessionClient.getDeviceSessionId(viewController,successSessionID, failureSessionID)

    }
    
    public func createPaymentMethod(paymentMethod: PaymentMethod) async throws -> PaymentMethodResponse {
        if paymentMethod.customerId == nil && paymentMethod.deviceSessionId == nil {
            throw OrkestapayError(errorDescription: "It is necessary to send customerId or deviceSessionId")
        }
        do {
            let response = try await self.orkestapayAPI.createPaymentMethod(pMethodRequest: paymentMethod)
            return response
        } catch let error as CoreSDKError{
            throw OrkestapayError(errorDescription: error.errorDescription)
        } catch {
            throw OrkestapayError(errorDescription: error.localizedDescription)
        }
    }
    
    public func getPromotions(binNumber: String, currency: String, totalAmount: String) async throws -> [PromotionsResponse] {
        do {
            let response = try await self.orkestapayAPI.getPromotions(binNumber: binNumber, currency: currency, totalAmount: totalAmount)
            return response
        } catch let error as CoreSDKError{
            throw OrkestapayError(errorDescription: error.errorDescription)
        } catch {
            throw OrkestapayError(errorDescription: error.localizedDescription)
        }
    }
    
    public func clickToPayCheckout(clickToPay: ClickToPay, onSuccess: @escaping (PaymentMethodResponse) -> (), onError: @escaping ([String: Any]) -> (), onCancel: @escaping () -> ()) {
        self.onCancel = onCancel
        let clickToPayViewController = ClickToPayViewController(config, clickToPay, onSuccess, onError, onCancel)
        if !clickToPayViewController.showWebView() {
            return
        }
        clickToPayViewController.presentationController?.delegate = self
        clickToPayViewController.loadCheckout()
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.onCancel()
    }
}
