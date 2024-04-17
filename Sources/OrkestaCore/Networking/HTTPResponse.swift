//
//  HTTPResponse.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation

struct HTTPResponse {
    
    let status: Int
    let body: Data?

    var isSuccessful: Bool { (200..<300).contains(status) }
}
