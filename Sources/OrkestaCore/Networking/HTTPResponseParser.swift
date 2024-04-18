//
//  HTTPResponseParser.swift
//  
//
//  Created by Hector Rodriguez on 08/04/24.
//

import Foundation

class HTTPResponseParser {
    
    private let decoder: JSONDecoder
    
    // MARK: - Initializer

    init(decoder: JSONDecoder = JSONDecoder()) { // exposed for test injection
        self.decoder = decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public Methods

    func parseREST<T: Decodable>(_ httpResponse: HTTPResponse, as type: T.Type) throws -> T {
        guard let data = httpResponse.body else {
            throw NetworkingClientError.noResponseDataError
        }
        
        if httpResponse.isSuccessful {
            return try parseSuccessResult(data, as: T.self)
        } else {
            return try parseErrorResult(data, as: T.self)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func parseSuccessResult<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkingClientError.jsonDecodingError(error.localizedDescription)
        }
    }
    
    private func parseErrorResult<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let errorData = try decoder.decode(ErrorResponse.self, from: data)
            throw NetworkingClientError.serverResponseError((errorData.message ?? errorData.error ?? NetworkingClientError.unknownError.errorDescription)!)
        } catch {
            throw NetworkingClientError.jsonDecodingError(error.localizedDescription)
        }
    }
}
