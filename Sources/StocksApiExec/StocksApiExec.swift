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
//        await testQuoteDatas()
        await apiQuoteDatas()

        
//        await searchCompany()
//        await apiCompanyDatas()
    }
    
    static func testQuoteDatas() async {
        
        let stringData = "{\"resultCode\":\"success\",\"result\":{\"pollingInterval\":70000,\"areas\":[{\"name\":\"SERVICE_ITEM\",\"datas\":[{\"cd\":\"005930\",\"nm\":\"삼성전자\",\"sv\":70500,\"nv\":69500,\"cv\":1000,\"cr\":1.42,\"rf\":\"5\",\"mt\":\"1\",\"ms\":\"CLOSE\",\"tyn\":\"N\",\"pcv\":70500,\"ov\":69700,\"hv\":70000,\"lv\":69400,\"ul\":91600,\"ll\":49400,\"aq\":13058271,\"aa\":909048000000,\"nav\":null,\"keps\":8057,\"eps\":5240,\"bps\":51385.16247,\"cnsEps\":1264,\"dv\":1444.00000}]}],\"time\":1697717453363}}"

        do {
            try await stocksApi.testfetchQuote(stringData: stringData)
        } catch {
            print(error.localizedDescription)
        }

    }
    
    static func apiQuoteDatas() async {
        do {
            let quotes = try await stocksApi.fetchQuote(symbol: "005930")
            print(quotes)
        } catch {
            print(error.localizedDescription)
        }
    }

    static func apiTradeDatas() async {
        do {
            let quotes = try await stocksApi.fetchTrade(symbol: "005930", startTime: "20230901", endTime: "20230913", timeframe: "day")
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
    
    static func getTradeDatas() async {
        let (result, _) = try! await URLSession.shared.data(from: URL(string: "https://api.finance.naver.com/siseJson.naver?symbol=005930&requestType=1&startTime=20231010&endTime=20231013&timeframe=day")!)
        
        guard let stringData = String(data: result, encoding: .utf8) else { return }
        let jsonString = stringData.replacingOccurrences(of: "'", with: "\"")

        guard let jsonData = jsonString.data(using: .utf8) else { return }
        do {
            let stockDataList = try JSONDecoder().decode(TradeResponse.self, from: jsonData)
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

            let compines = try JSONDecoder().decode(TickerResponse.self, from: searchData)
            print(compines.items)
        } catch let error {
            print("Search error: \(error)")
        }
    }
    
}
