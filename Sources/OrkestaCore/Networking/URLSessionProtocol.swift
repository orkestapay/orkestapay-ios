//
//  URLSessionProtocol.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation

protocol URLSessionProtocol {
    
    func performRequest(with urlRequest: URLRequest) async throws -> (Data, URLResponse)
}
