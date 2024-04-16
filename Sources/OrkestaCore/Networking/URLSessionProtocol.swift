//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation

public protocol URLSessionProtocol {
    
    func performRequest(with urlRequest: URLRequest) async throws -> (Data, URLResponse)
}
