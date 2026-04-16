//
//  PaymentOption.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 20/01/25.
//

import Foundation

public struct PaymentOption: Codable {
    public let promotionId: String?
    public let promotionName: String?
    public let type: String?
    public let installments: Int?
    public let issuerId: String?
    public let issuerName: String?

}
