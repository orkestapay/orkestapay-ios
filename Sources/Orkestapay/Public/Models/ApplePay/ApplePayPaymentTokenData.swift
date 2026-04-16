//
//  ApplePaymentTokenData.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 10/10/24.
//

import Foundation

public struct ApplePayPaymentTokenData: Codable {
    public let data: String
    public let header: ApplePayPaymentTokenDataHeader
    public let signature: String
    public let version: String

}
