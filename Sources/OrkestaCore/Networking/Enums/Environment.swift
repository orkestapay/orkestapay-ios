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
            return URL(string: "https://api.sand.orkestapay.com")!
        case .production:
            return URL(string: "https://api.orkestapay.com")!
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
