//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/13/23.
//

import Foundation
import StocksApi

@main
struct StocksApiExec {
    
    static func main() async {
        let (result, _) = try! await URLSession.shared.data(from: URL(string: "https://api.finance.naver.com/siseJson.naver?symbol=005930&requestType=1&startTime=20231010&endTime=20231013&timeframe=day")!)
        
        guard let stringData = String(data: result, encoding: .utf8) else { return }
        let jsonString = stringData.replacingOccurrences(of: "'", with: "\"")

        guard let jsonData = jsonString.data(using: .utf8) else { return }
        do {
            let stockDataList = try JSONDecoder().decode(StockDataList.self, from: jsonData)
            let stockDatas = stockDataList.stockDatas
            print(stockDatas)
        } catch let error {
            print("Decoding error: \(error)")
        }
        
        do {
            let (searchData, _) = try await URLSession.shared.data(from: URL(string: "https://ac.stock.naver.com/ac?q=sk&target=index%2Cstock%2Cmarketindicator")!)
            let compines = try JSONDecoder().decode(CompanyResponse.self, from: searchData)
            print(compines.items)
        } catch let error {
            print("Search error: \(error)")
        }
    }
    
}
