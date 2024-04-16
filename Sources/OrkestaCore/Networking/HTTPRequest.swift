//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation

public struct HTTPRequest {
    
    let headers: [HTTPHeader: String]
    let method: HTTPMethod
    let url: URL
    let body: Data?

    public init(
        headers: [HTTPHeader: String],
        method: HTTPMethod,
        url: URL,
        body: Data?
    ) {
        self.headers = headers
        self.method = method
        self.url = url
        self.body = body
    }
}
