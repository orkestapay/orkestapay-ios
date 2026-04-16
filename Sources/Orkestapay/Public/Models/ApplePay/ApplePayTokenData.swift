//
//  ApplePayTokenData.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 10/10/24.
//

public struct ApplePayTokenData: Encodable {
    public var type: PaymentMethodType
    public var data: String
    public var header: ApplePayPaymentTokenDataHeader
    public var signature: String
    public var version: String

    public init(
        type: PaymentMethodType,
        data: String,
        header: ApplePayPaymentTokenDataHeader,
        signature: String,
        version: String
    ) {
        self.type = type
        self.data = data
        self.header = header
        self.signature = signature
        self.version = version
    }
}
