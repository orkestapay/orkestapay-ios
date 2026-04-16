//
//  Card.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public struct Card: Encodable {
    public var number: String
    public var expirationMonth: String
    public var expirationYear: String
    public var cvv: String
    public var holderName: String
    public var oneTimeUse: Bool

    public init(
        number: String,
        expirationMonth: String,
        expirationYear: String,
        cvv: String,
        holderName: String,
        oneTimeUse: Bool
    ) {
        self.number = number
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
        self.holderName = holderName
        self.oneTimeUse = oneTimeUse
    }
}
