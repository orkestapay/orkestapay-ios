//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 16/04/24.
//

import Foundation

public struct PromotionsResponse: Codable {
    public let type: String
    public let installments: [Int]
}
