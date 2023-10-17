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
    
    public func fetchQuote(symbol: String, startTime: String, endTime: String, timeframe: String) async throws -> [Quote] {
//        guard var urlComponents = URLComponents(stirng: "\(baseURL)/sideJon.naver") else {
//            throw APIError.invalidURL
//        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseHost
        urlComponents.path = "/siseJson.naver"

        // Create query items
        let symbolQuery = URLQueryItem(name: "symbol", value: symbol)
        let requestTypeQuery = URLQueryItem(name: "requestType", value: String(1))
        let startTimeQuery = URLQueryItem(name: "startTime", value: startTime)
        let endTimeQuery = URLQueryItem(name: "endTime", value: endTime)
        let timeframeQuery = URLQueryItem(name: "timeframe", value: timeframe)

        // Set the query items for the URL
        urlComponents.queryItems = [symbolQuery, requestTypeQuery, startTimeQuery, endTimeQuery, timeframeQuery]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        let (response, statusCode): (QuoteResponse, Int) = try await fetch(url: url, shouldReplace: true, from: "'", to: "\"")
        if let error = response.error {
            throw APIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.datas

    }
    
    private func fetch<D: Decodable>(url: URL, shouldReplace: Bool = false, from: String = "", to: String = "") async throws -> (D, Int) {
        let (data, res) = try await session.data(from: url)
        let statusCode = try validateHTTPResponseCode(res)
//        if shouldReplace {
//            guard let stringData = String(data: data, encoding: .utf8) else {
//                throw APIError.parseError
//            }
//            let jsonString = stringData.replacingOccurrences(of: from, with: to)
//
//            guard let jsonData = jsonString.data(using: .utf8) else {
//                throw APIError.parseError
//            }
//            return (try jsonDecoder.decode(D.self, from: jsonData), statusCode)
//
//        }
//        return (try jsonDecoder.decode(D.self, from: data), statusCode)
        
        let targetData = shouldReplace ? try {
            let stringData = String(data: data, encoding: .utf8)
            let jsonString = stringData?.replacingOccurrences(of: from, with: to)
            if let jsonData = jsonString?.data(using: .utf8) {
                return jsonData
            } else {
                throw APIError.parseError
            }
        }() : data

//        guard let validData = targetData else {
//            throw APIError.parseError
//        }

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


