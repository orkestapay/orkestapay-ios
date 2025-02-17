//
//  NetworkingClient.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation


class NetworkingClient {
        
    // MARK: - Internal Properties
    
    private var http: OrkestaHTTP
    private let coreConfig: CoreConfig
    
    // MARK: - Public Initializer

    init(coreConfig: CoreConfig) {
        self.http = OrkestaHTTP(coreConfig: coreConfig)
        self.coreConfig = coreConfig
    }
    
    
    // MARK: - Public Methods

    func fetch(request: RESTRequest) async throws -> HTTPResponse {
        let url = try constructRESTURL(path: request.path, queryParameters: request.queryParameters)
        
        let base64EncodedCredentials = Data(coreConfig.merchantId.appending(":").appending(coreConfig.publicKey).utf8).base64EncodedString()
        //var headers: [HTTPHeader: String] = [:]
        
        var headers: [HTTPHeader: String] = [
            .authorization: "Basic \(base64EncodedCredentials)"
        ]
        //print(headers)
        if request.method == .post {
            headers[.contentType] = "application/json"
        }
        
        var data: Data?
        if let postBody = request.postParameters {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            data = try encoder.encode(postBody)
        }
        
        let httpRequest = HTTPRequest(headers: headers, method: request.method, url: url, body: data)
        
        return try await http.performRequest(httpRequest)
    }
    
    // MARK: - Private Methods
    
    private func constructRESTURL(path: String, queryParameters: [String: String]?) throws -> URL {
        let urlString = coreConfig.environment.baseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: urlString, resolvingAgainstBaseURL: false)
        
        if let queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = urlComponents?.url else {
            throw NetworkingClientError.urlEncodingFailed
        }
        
        return url
    }
}
