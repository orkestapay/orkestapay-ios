//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 15/04/24.
//

import Foundation

public struct OrkestapayError: Error, LocalizedError {
    public let errorDescription: String?

    public init(errorDescription: String?) {
        self.errorDescription = errorDescription
    }
}
