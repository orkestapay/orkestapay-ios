//
//  ErrorResponse.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

struct ErrorResponse: Codable {

    let requestId: String
    let category: String?
    let message: String?
    let error: String?
    

}
