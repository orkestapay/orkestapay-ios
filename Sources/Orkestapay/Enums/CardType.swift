//
//  CardType.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public enum CardType: String, Codable {
    case DEBIT = "DEBIT"
    case CREDIT = "CREDIT"
    case PREPAID = "PREPAID"
    case CHARGE = "CHARGE"
    case UNKNOWN = "UNKNOWN"
}
