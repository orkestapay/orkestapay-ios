//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

public struct PaymentMethodRequest: Encodable {

    public var customerId: String?
    public var alias: String
    public var type: PaymentMethodType
    public var deviceSessionId: String
    public var card: CardRequest

    public init(
        customerId: String,
        alias: String,
        type: PaymentMethodType,
        deviceSessionId: String,
        card: CardRequest
    ) {
        self.customerId = customerId
        self.alias = alias
        self.type = type
        self.deviceSessionId = deviceSessionId
        self.card = card
    }
}
