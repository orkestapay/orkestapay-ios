//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

public struct CoreConfig {

    public let environment: Environment
    public let merchantId: String
    public let publicKey: String

    public init(merchantId: String, publicKey: String, environment: Environment) {
        self.merchantId = merchantId
        self.publicKey = publicKey
        self.environment = environment
    }
}
