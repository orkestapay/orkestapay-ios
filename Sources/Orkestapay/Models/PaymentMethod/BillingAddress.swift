//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 29/04/24.
//

import Foundation

public struct BillingAddress: Encodable {
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: Phone?
    public var type: String?
    public var line_1: String
    public var line_2: String?
    public var city: String
    public var state: String
    public var country: String
    public var zipCode: String

    public init(
        firstName: String?,
        lastName: String?,
        email: String?,
        phone: Phone?,
        type: String?,
        line1: String,
        line2: String?,
        city: String,
        state: String,
        country: String,
        zipCode: String
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.type = type
        self.line_1 = line1
        self.line_2 = line2
        self.city = city
        self.state = state
        self.country = country
        self.zipCode = zipCode
    }
}
