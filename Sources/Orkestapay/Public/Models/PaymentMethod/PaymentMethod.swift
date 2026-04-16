//
//  PaymentMethod.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

public struct PaymentMethod: Encodable {
    public var alias: String?
    public var customerId: String?
    public var deviceSessionId: String?
    public var type: PaymentMethodType
    public var card: Card
    public var billingAddress: BillingAddress?

    public init(
        alias: String?,
        customerId: String?,
        deviceSessionId: String?,
        card: Card,
        billingAddress: BillingAddress?
    ) {
        self.customerId = customerId
        self.alias = alias
        self.type = .CARD
        self.deviceSessionId = deviceSessionId
        self.card = card
        self.billingAddress = billingAddress
    }
}
