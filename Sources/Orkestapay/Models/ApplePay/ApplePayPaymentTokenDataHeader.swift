//
//  ApplePayPaymentTokenDataHeader.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 10/10/24.
//

public struct ApplePayPaymentTokenDataHeader: Codable {
    public let ephemeralPublicKey: String
    public let publicKeyHash: String
    public let transactionId: String

}
