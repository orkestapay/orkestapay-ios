//
//  ClickToPay.swift
//  
//
//  Created by Hector Rodriguez on 11/09/24.
//

import Foundation

public struct ClickToPay: Encodable {
    public var email: String?
    public var firstName: String?
    public var lastName: String?
    public var phoneCountryCode: String?
    public var phoneNumber: String?
    public var isCscRequired: Bool?
    public var isSandbox: Bool?
    

    public init(
        email: String?,
        firstName: String?,
        lastName: String?,
        phoneCountryCode: String?,
        phoneNumber: String?,
        isCscRequired: Bool?,
        isSandbox: Bool?
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneCountryCode = phoneCountryCode
        self.phoneNumber = phoneNumber
        self.isCscRequired = isCscRequired
        self.isSandbox = isSandbox
    }
}
