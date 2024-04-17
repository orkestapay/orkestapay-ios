//
//  PaymentMethodResponse.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public struct PaymentMethodResponse: Codable {

    public let paymentMethodId: String
    public let alias: String?
    public let type: PaymentMethodType
    public let card: CardResponse

}
