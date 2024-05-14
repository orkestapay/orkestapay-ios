//
//  PromotionsResponse.swift
//  
//
//  Created by Hector Rodriguez on 16/04/24.
//

import Foundation

public struct PromotionsResponse: Codable {
    public let promotionId: String
    public let promotionName: String
    public let type: String
    public let installments: [Int]
    public let issuerId: String?
    public let issuerName: String?
    public let currencyCode: String?
    public let minimumAmount: Int?
    public let maximumAmount: Int?
}
