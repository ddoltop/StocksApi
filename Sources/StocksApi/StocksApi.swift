// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct StocksApi {
    private let session = URLSession.shared
    private let jsonDecoder = {
        let decode = JSONDecoder()
        decode.dateDecodingStrategy = .secondsSince1970 //yahoo
        return decode
    }()
    
    private let baseHost = "api.finance.naver.com"
    
    public init() {
        
    }
    
    public func searchCompany(query: String, isEquityTypeOnly: Bool = false) async throws -> [Ticker] {
        // "https://ac.stock.naver.com/ac?q=sk&target=index%2Cstock%2Cmarketindicator")!)
        var components = URLComponents(scheme: "https", host: "ac.stock.naver.com", path: "/ac")
        
        components.percentEncodedQuery = "q=\(query)&target=index%2Cstock%2Cmarketindicator"

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let (response, statusCode): (TickerResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.items
    }
    
    public func testfetchQuote(stringData: String) async throws {
        guard let jsonData = stringData.data(using: .utf8) else {
            fatalError("Failed to convert string to data")
        }
        
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(QuoteResponse.self, from: jsonData)
            switch response {
            case .success(let data):
                print("Success: \(data)")
            case .error(let errorData):
                print("Error: \(errorData)")
            }
        } catch let error {
            print("Decoding error: \(error)")
        }
    }

    
    public func fetchQuote(symbol: String) async throws -> [Quote] {
        // https://polling.finance.naver.com/api/realtime?query=SERVICE_ITEM:031510,005930
        var urlComponents = URLComponents(scheme: "https", host: "polling.finance.naver.com", path: "/api/realtime")
        urlComponents.queryItems = [
            .init(name: "query", value: "SERVICE_ITEM:\(symbol)")
        ]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        do {
            let (response, statusCode): (QuoteResponse, Int) = try await fetch(url: url,shouldReplace: true)
            switch response {
            case .success(let data):
//                print("Success: \(data)")
                return data.result.areas[0].datas
            case .error(let errorData):
                print("Error: \(errorData)")
                throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: ErrorResponse(error: errorData.error, message: errorData.message))
            }
        } catch let error {
            print("Decoding error: \(error)")
            throw APIError.parseError
        }
    }
    
    public func fetchTrade(symbol: String, startTime: String, endTime: String, timeframe: String) async throws -> [Trade] {
        var urlComponents = URLComponents(scheme: "https", host: "api.finance.naver.com", path: "/siseJson.naver")
        // https://api.finance.naver.com/siseJson.naver?symbol=005930&requestType=1&startTime=20230901&endTime=20231013&timeframe=day
        // https://api.finance.naver.com/siseJson.naver?symbol=005930&startTime=20230901&endTime=20230913&timeframe=day"
        // Set the query items for the URL
        urlComponents.queryItems = [
            .init(name: "symbol", value: symbol),
            .init(name: "requestType", value: String(1)),
            .init(name: "startTime", value: startTime),
            .init(name: "endTime", value: endTime),
            .init(name: "timeframe", value: timeframe),
        ]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        let (response, statusCode): (TradeResponse, Int) = try await fetch(url: url, shouldReplace: true, "'", "\"")
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.datas

    }
    private func fetch<D: Decodable>(url: URL, shouldReplace: Bool = false, _ from: String = "", _ to: String = "") async throws -> (D, Int) {
        let (data, res) = try await session.data(from: url)
        let statusCode = try validateHTTPResponseCode(res)
        
        let targetData = shouldReplace ? try {
            
            let eucKR = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))

            guard let stringData = String(data: data, encoding: String.Encoding(rawValue: eucKR)) else {
                print("Failed to convert data to EUC-KR string.")
                throw APIError.parseError
            }

//            let stringData = String(bytes: data, encoding: .utf8) ?? ""
            let jsonString = stringData.replacingOccurrences(of: from, with: to)
            if let jsonData = jsonString.data(using: .utf8) {
                return jsonData
            } else {
                throw APIError.parseError
            }
        }() : data

        return (try JSONDecoder().decode(D.self, from: targetData), statusCode)

    }
    
    private func validateHTTPResponseCode(_ response: URLResponse) throws -> Int {
        guard let res = response as? HTTPURLResponse else {
            throw APIError.invalidResponseType
        }
        
        guard 200...299 ~= res.statusCode || 400...499 ~= res.statusCode else {
            throw APIError.httpStatusCodeFailed(statusCode: res.statusCode, error: nil)
        }
        return res.statusCode
    }
    
}

extension URLComponents {
    
    init(scheme: String, host: String, path: String) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
    }

    init(scheme: String, host: String, path: String, queryItems: [URLQueryItem]?) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}
