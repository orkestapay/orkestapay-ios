//
//  OrkestaHTTP.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation


class OrkestaHTTP {
    
    let coreConfig: CoreConfig
    private var urlSession: URLSessionProtocol

    init(
        urlSession: URLSessionProtocol = URLSession.shared, coreConfig: CoreConfig
    ) {
        self.urlSession = urlSession
        self.coreConfig = coreConfig
    }
    
    func performRequest(_ httpRequest: HTTPRequest) async throws -> HTTPResponse {
        var urlRequest = URLRequest(url: httpRequest.url)
        urlRequest.httpMethod = httpRequest.method.rawValue
        urlRequest.httpBody = httpRequest.body
        
        httpRequest.headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key.rawValue)
        }
        let (data, response) = try await urlSession.performRequest(with: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkingClientError.invalidURLResponseError
        }
        
        return HTTPResponse(status: response.statusCode, body: data)
    }
}
