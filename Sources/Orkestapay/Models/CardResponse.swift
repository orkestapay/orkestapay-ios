//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public struct CardResponse: Codable {
    let bin: String
    let lastFour: String
    let brand: String
    let cardType: CardType
    let expirationMonth: String
    let expirationYear: String
    let holderName: String
    let holderLastName: String?
    let oneTimeUse: Bool
}

