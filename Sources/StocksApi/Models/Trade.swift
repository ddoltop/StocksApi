//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/13/23.
//
import Foundation

public struct ChartData {
//    public let meta: ChartMeta
    public let data: [Trade]
    
    public init(data: [Trade]) {
        self.data = data
    }
}

public struct Trade: Decodable {
//    public let id = UUID()
    
    public var timestamp: Date? {
        stringToDate(date)
    }
    public let date: String
    public let openPrice: Int?
    public let highPrice: Int?
    public let lowPrice: Int?
    public let closePrice: Int?
    public let volume: Int?
    public let foreignHoldingRate: Double?

    enum CodingKeys: Int, CodingKey {
        case date = 0
        case openPrice = 1
        case highPrice = 2
        case lowPrice = 3
        case closePrice = 4
        case volume = 5
        case foreignHoldingRate = 6
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        date = try container.decode(String.self)
        openPrice = try container.decodeIfPresent(Int.self)
        highPrice = try container.decodeIfPresent(Int.self)
        lowPrice = try container.decodeIfPresent(Int.self)
        closePrice = try container.decodeIfPresent(Int.self)
        volume = try container.decodeIfPresent(Int.self)
        foreignHoldingRate = try container.decodeIfPresent(Double.self)
//        timestamp = stringToDate(date)!
    }
    
    func stringToDate(_ dateStr: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        if dateStr.count == 12 {
            dateFormatter.dateFormat = "yyyyMMddHHmm"
        } else if dateStr.count == 8 {
            dateFormatter.dateFormat = "yyyyMMdd"
        } else {
            // Return nil if the format is unrecognized
            return nil
        }
//        dateFormatter.dateFormat = "yyyyMMddHHmm"
        return dateFormatter.date(from: dateStr)
    }

}


public struct TradeResponse: Decodable {
    public let datas: [Trade]
    public let error: ErrorResponse?
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        // Skip the header row
        _ = try container.decode([String].self)
        
        var datas = [Trade]()
        while !container.isAtEnd {
            let data = try container.decode(Trade.self)
            datas.append(data)
        }
        
        self.datas = datas
        self.error = nil
    }
}



//
//// Sample JSON
//let jsonString = """
//[
//    ["날짜", "시가", "고가", "저가", "종가", "거래량", "외국인소진율"],
//    ["20230102", 55500, 56100, 55200, 55500, 10031448, 49.67],
//    // ... rest of the data
//]
//"""
//

//let jsonData = jsonString.data(using: .utf8)!
//let stockDataList = try! JSONDecoder().decode(StockDataList.self, from: jsonData)
//let stockDatas = stockDataList.stockDatas
