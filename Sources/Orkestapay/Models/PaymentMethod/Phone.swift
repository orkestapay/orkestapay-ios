//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 29/04/24.
//

import Foundation

public struct Phone: Encodable {
    public var number: String
    public var countryCode: String

    public init(
        number: String,
        countryCode: String
    ) {
        self.number = number
        self.countryCode = countryCode
    }
}
