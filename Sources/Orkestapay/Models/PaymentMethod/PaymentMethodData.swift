//
//  PaymentMethodData.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 14/10/24.
//

public struct PaymentMethodData: Codable {
    public let id: String
    public let merchantId: String
    public let type: String
    public let order: Int
    public let status: String
    public let properties: PaymentMethodProperties
}

