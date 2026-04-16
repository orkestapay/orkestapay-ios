//
//  PaymentMethod2RegistryApplePay.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 10/10/24.
//

public struct PaymentMethod2RegistryApplePay: Encodable {
    public var type: PaymentMethodType
    public var customerId: String?
    public var applePay: ApplePayTokenData

    public init(
        type: PaymentMethodType,
        customerId: String?,
        applePay: ApplePayTokenData
    ) {
        self.type = type
        self.customerId = customerId
        self.applePay = applePay
    }
}
