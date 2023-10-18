//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/13/23.
//

import Foundation


public struct CompanyResponse: Codable {
    public let query: String //do not change
    public let items: [Company] //do not change
    public let error: ErrorResponse?
}


public struct Company: Codable, Identifiable, Hashable, Equatable {
    
//    public let id = UUID()
    
    public let code: String
    public let name: String
    public let typeCode: String
    public let url: String
    public let reutersCode: String
    public let nationCode: String
    public let nationName: String
    
    public var id: String {
        code
    }
}
