//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation

public struct CoreSDKError: Error, LocalizedError {

    /// The error code.
    public let code: Int?

    /// A string containing the error domain.
    public let domain: String?

    /// A string containing the localized description of the error.
    public let errorDescription: String?

    public init(code: Int?, domain: String?, errorDescription: String?) {
        self.code = code
        self.domain = domain
        self.errorDescription = errorDescription
    }
}
