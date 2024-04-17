//
//  RESTRequest.swift
//  
//
//  Created by Hector Rodriguez on 05/04/24.
//

import Foundation

struct RESTRequest {
    
    var path: String
    var method: HTTPMethod
    var queryParameters: [String: String]?
    var postParameters: Encodable?
    
    init(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: String]? = nil,
        postParameters: Encodable? = nil
    ) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.postParameters = postParameters
    }
}
