//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/13/23.
//

import Foundation


public struct TickerResponse: Codable {
    public let query: String //do not change
    public let items: [Ticker] //do not change
    public let error: ErrorResponse?
}


public struct Ticker: Codable, Identifiable, Hashable, Equatable {
    
//    public let id = UUID()
    
    public let code: String
    public let name: String?
    public let typeCode: String?
    public let url: String?
    public let reutersCode: String?
    public let nationCode: String?
    public let nationName: String?
    
    public var id: String {
        code
    }
    
    public init(code: String, name: String?=nil, typeCode: String?=nil, url: String?=nil, reutersCode: String?=nil, nationCode: String?=nil, nationName: String?=nil) {
        self.code = code
        self.name = name
        self.typeCode = typeCode
        self.url = url
        self.reutersCode = reutersCode
        self.nationCode = nationCode
        self.nationName = nationName
    }
}
