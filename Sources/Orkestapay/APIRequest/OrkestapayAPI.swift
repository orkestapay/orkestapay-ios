//
//  File.swift
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
}
