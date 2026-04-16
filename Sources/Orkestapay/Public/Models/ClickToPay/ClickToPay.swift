//
//  ClickToPay.swift
//  
//
//  Created by Hector Rodriguez on 11/09/24.
//

import Foundation

public struct ClickToPay: Encodable {
    public var email: String
    public var firstName: String?
    public var lastName: String?
    public var phoneCountryCode: String?
    public var phoneNumber: String?
    public var totalAmount: String
    public var currency: String
    

    public init(
        email: String,
        firstName: String?,
        lastName: String?,
        phoneCountryCode: String?,
        phoneNumber: String?,
        totalAmount: String,
        currency: String
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneCountryCode = phoneCountryCode
        self.phoneNumber = phoneNumber
        self.totalAmount = totalAmount
        self.currency = currency
    }
}
