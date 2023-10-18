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
    
    static let stocksApi = StocksApi()
    
    static func main() async {
//        await getQuoteDatas()
        await apiQuoteDatas()

        
//        await searchCompany()
//        await apiCompanyDatas()
    }
    
    static func apiQuoteDatas() async {
        do {
            let quotes = try await stocksApi.fetchQuote(symbol: "005930", startTime: "20230901", endTime: "20230913", timeframe: "day")
            print(quotes)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    static func apiCompanyDatas() async {
        do {
            let companies = try await stocksApi.searchCompany(query: "sk")
            print(companies)
        } catch {
            print(error.localizedDescription)
        }
    }
    static func getQuoteDatas() async {
        let (result, _) = try! await URLSession.shared.data(from: URL(string: "https://api.finance.naver.com/siseJson.naver?symbol=005930&requestType=1&startTime=20231010&endTime=20231013&timeframe=day")!)
        
        guard let stringData = String(data: result, encoding: .utf8) else { return }
        let jsonString = stringData.replacingOccurrences(of: "'", with: "\"")

        guard let jsonData = jsonString.data(using: .utf8) else { return }
        do {
            let stockDataList = try JSONDecoder().decode(QuoteResponse.self, from: jsonData)
            let stockDatas = stockDataList.datas
            print(stockDatas)
        } catch let error {
            print("Decoding error: \(error)")
        }
        
    }
    
    static func searchCompany() async {
        do {
            let (searchData, _) = try await URLSession.shared.data(from: URL(string: "https://ac.stock.naver.com/ac?q=sk&target=index%2Cstock%2Cmarketindicator")!)
//            if let stringData = String(data: searchData, encoding: .utf8) {
//                print("stringData:")
//                print(stringData)
//            }

            let compines = try JSONDecoder().decode(CompanyResponse.self, from: searchData)
            print(compines.items)
        } catch let error {
            print("Search error: \(error)")
        }
    }
    
}
