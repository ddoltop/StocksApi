//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/16/23.
//

import Foundation


//struct ErrorResponse: Decodable {
//    let timestamp: String
//    let status: Int
//    let error: String
//    let message: String
//    let path: String
//}
//

public struct ErrorResponse: Codable {
    
    public let error: String
    public let message: String
    
    public init(error: String, message: String) {
        self.error = error
        self.message = message
    }
}

//{
//    "timestamp": "2023-10-19T04:25:08.982+0000",
//    "status": 400,
//    "error": "Bad Request",
//    "message": "Required String parameter 'query' is not present",
//    "path": "/api/realtime"
//}
