//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public struct PaymentMethodResponse: Codable {

    let paymentMethodId: String
    let alias: String?
    let type: PaymentMethodType
    let card: CardResponse

}
