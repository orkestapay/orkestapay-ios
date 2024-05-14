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
        var id = merchantId;
        if !merchantId.starts(with: "mid_") {
            id = "mid_\(id)"
        }
        self.merchantId = id
        self.publicKey = publicKey
        self.environment = environment
    }
}
