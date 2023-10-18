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
    
    public func searchCompany(query: String, isEquityTypeOnly: Bool = false) async throws -> [Company] {
        // "https://ac.stock.naver.com/ac?q=sk&target=index%2Cstock%2Cmarketindicator")!)
        var components = URLComponents(scheme: "https", host: "ac.stock.naver.com", path: "/ac")
        
        components.percentEncodedQuery = "q=\(query)&target=index%2Cstock%2Cmarketindicator"

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let (response, statusCode): (CompanyResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.items
    }
    
    public func fetchQuote(symbol: String, startTime: String, endTime: String, timeframe: String) async throws -> [Quote] {
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

        let (response, statusCode): (QuoteResponse, Int) = try await fetch(url: url, shouldReplace: true, "'", "\"")
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.datas

    }
    
    private func fetch<D: Decodable>(url: URL, shouldReplace: Bool = false, _ from: String = "", _ to: String = "") async throws -> (D, Int) {
        let (data, res) = try await session.data(from: url)
        let statusCode = try validateHTTPResponseCode(res)
        
        let targetData = shouldReplace ? try {
            let stringData = String(data: data, encoding: .utf8)
            print(stringData)
            let jsonString = stringData?.replacingOccurrences(of: from, with: to)
            if let jsonData = jsonString?.data(using: .utf8) {
                return jsonData
            } else {
                throw APIError.parseError
            }
        }() : data

        return (try jsonDecoder.decode(D.self, from: targetData), statusCode)

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
