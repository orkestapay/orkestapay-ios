//
//  CoreConfig.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

struct CoreConfig {

    let environment: Environment
    let merchantId: String
    let publicKey: String

    init(merchantId: String, publicKey: String, environment: Environment) {
        self.merchantId = merchantId
        self.publicKey = publicKey
        self.environment = environment
    }
}
