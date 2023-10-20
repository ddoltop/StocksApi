//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/16/23.
//

import Foundation

public enum APIError: CustomNSError {
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int, error: ErrorResponse?)
    case parseError
    
    public static var errorDomain: String {
        "StocksApi"
    }
    
    public var errorCode: Int {
        switch self {
        case .invalidURL: return 0
        case .invalidResponseType: return 1
        case .httpStatusCodeFailed: return 2
        case .parseError: return 3
        }
    }
    
    public var errorUserInfo: [String : Any] {
        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid response type"
        case let .httpStatusCodeFailed(statusCode, error):
            if let error = error {
                text = "Error: Status Code: \(statusCode), error: \(error.error), message: \(error.message)"
            } else {
                text = "Error: Status Code: \(statusCode)"
            }
        case .parseError:
            text = "Error: Parsing Error"
        }
        
        return [NSLocalizedDescriptionKey: text]
    }
    
}
