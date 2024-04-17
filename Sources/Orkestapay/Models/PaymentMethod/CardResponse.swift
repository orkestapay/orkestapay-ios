//
//  CardResponse.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public struct CardResponse: Codable {
    public let bin: String
    public let lastFour: String
    public let brand: String
    public let cardType: CardType
    public let expirationMonth: String
    public let expirationYear: String
    public let holderName: String
    public let holderLastName: String?
    public let oneTimeUse: Bool
}

