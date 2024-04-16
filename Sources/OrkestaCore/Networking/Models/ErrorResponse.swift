//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

struct ErrorResponse: Codable {

    let name: String
    let message: String?

    var readableDescription: String {
        if let message = message {
            return name + ": " + message
        } else {
            return name
        }
    }
}
