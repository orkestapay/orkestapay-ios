//
//  OrkestapayClient.swift
//
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation
#if canImport(OrkestaCore)
import OrkestaCore
#endif

public class OrkestapayClient: NSObject {
    private let config: CoreConfig
    private let sessionDeviceClient: SessionDeviceClient
    private let orkestapayAPI: OrkestapayAPI
    
    
    public init(merchantId: String, publicKey:String, isProductionMode: Bool) {
        self.config = CoreConfig(merchantId: merchantId, publicKey: publicKey, environment: isProductionMode ? .production : .sandbox)
        self.sessionDeviceClient = SessionDeviceClient(coreConfig: config)
        self.orkestapayAPI = OrkestapayAPI(coreConfig: config)
    }
    
    
    public func createSessionDevice(successSessionID: @escaping (String) -> (), failureSessionID: @escaping (String) -> ()) {
        sessionDeviceClient.getSessionDeviceId(successSessionID, failureSessionID)

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
}
