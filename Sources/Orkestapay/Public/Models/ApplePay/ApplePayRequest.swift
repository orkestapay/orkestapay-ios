//
//  ApplePay.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 10/10/24.
//

import Foundation

public struct ApplePayRequest: Encodable {
    public var merchantName: String
    public var totalAmount: String
    public var countryCode: String
    public var currencyCode: String
    
    public init(
        merchantName: String,
        totalAmount: String,
        countryCode: String,
        currencyCode: String
    ) {
        self.merchantName = merchantName
        self.totalAmount = totalAmount
        self.countryCode = countryCode
        self.currencyCode = currencyCode
    }
}
