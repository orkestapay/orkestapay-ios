//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

public enum Environment {
    case sandbox
    case production

    var baseURL: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://api.dev.orkestapay.com")!
        case .production:
            return URL(string: "https://api.orkestapay.com")!
        }
    }

    var resourcesBaseURL: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://checkout.dev.orkestapay.com")!
        case .production:
            return URL(string: "https://resources.orkestapay.com")!
        }
    }
    
    public var toString: String {
        switch self {
        case .sandbox:
            return "sandbox"
        case .production:
            return "production"
        }
    }
}
