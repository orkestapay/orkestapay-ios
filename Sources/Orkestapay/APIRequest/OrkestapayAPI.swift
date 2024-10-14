//
//  OrkestapayAPI.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

#if canImport(OrkestaCore)
import OrkestaCore
#endif


class OrkestapayAPI {

    // MARK: - Private Properties

    private let coreConfig: CoreConfig
    private let networkingClient: NetworkingClient
    
    // MARK: - Initializer
    
    init(coreConfig: CoreConfig) {
        self.coreConfig = coreConfig
        self.networkingClient = NetworkingClient(coreConfig: coreConfig)
    }
    
    
    // MARK: - Internal Methods
        
    func createPaymentMethod(pMethodRequest: PaymentMethod) async throws -> PaymentMethodResponse {
        let restRequest = RESTRequest(
            path: "/v1/payment-methods",
            method: .post,
            queryParameters: nil,
            postParameters: pMethodRequest
        )
        
        let httpResponse = try await networkingClient.fetch(request: restRequest)
        return try HTTPResponseParser().parseREST(httpResponse, as: PaymentMethodResponse.self)
    }
    
    func createPaymentMethodApplePay(pMethodRequest: PaymentMethod2RegistryApplePay) async throws -> PaymentMethodResponse {
        let restRequest = RESTRequest(
            path: "/v1/payment-methods",
            method: .post,
            queryParameters: nil,
            postParameters: pMethodRequest
        )
        let httpResponse = try await networkingClient.fetch(request: restRequest)
        return try HTTPResponseParser().parseREST(httpResponse, as: PaymentMethodResponse.self)
    }
    
    func getPromotions(binNumber: String, currency: String, totalAmount: String) async throws -> [PromotionsResponse] {
        let queryParams: [String: String] = ["binNumber":binNumber, "currency":currency, "totalAmount": totalAmount]
        
        let restRequest = RESTRequest(
            path: "/v1/merchants/\(coreConfig.merchantId)/promotions",
            method: .get,
            queryParameters: queryParams,
            postParameters: nil
        )
        
        let httpResponse = try await networkingClient.fetch(request: restRequest)
        return try HTTPResponseParser().parseREST(httpResponse, as: [PromotionsResponse].self)
    }
    
    func getPaymentMethodInfo() async throws -> PaymentMethodData {
        let restRequest = RESTRequest(
            path: "/v1/merchants/payment-methods/APPLE_PAY",
            method: .get,
            queryParameters: nil,
            postParameters: nil
        )
        let httpResponse = try await networkingClient.fetch(request: restRequest)
        return try HTTPResponseParser().parseREST(httpResponse, as: PaymentMethodData.self)
    }
}
