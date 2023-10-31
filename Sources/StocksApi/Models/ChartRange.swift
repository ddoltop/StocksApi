//
//  File.swift
//  
//
//  Created by Jongmok Park on 10/16/23.
//

import Foundation

public enum ChartRange: String, CaseIterable {
    
    case oneDay = "1d"
    case oneWeek = "5d"
    case oneMonth = "1mo"
    case threeMonth = "3mo"
    case sixMonth = "6mo"
    case ytd
    case oneYear = "1y"
    case twoYear = "2y"
    case threeYear = "3y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case max
    
    public var interval: String {
        switch self {
        case .oneDay: return "1m"
        case .oneWeek: return "5m"
        case .oneMonth: return "90m"
        case .threeMonth, .sixMonth, .ytd, .oneYear, .twoYear: return "1d"
        case .threeYear, .fiveYear, .tenYear: return "1wk"
        case .max: return "3mo"
        }
    }
    
    public var endTime: String {
        return dateToString(Date())
    }
    
    public var startTime: String {

        switch self {
        case .oneDay:
            return dateToString(Date())
        case .oneWeek:
            return dateToString(Calendar.current.date(byAdding: .weekday, value: -1, to: Date())!)
        case .oneMonth:
            return dateToString(Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        case .threeMonth:
            return dateToString(Calendar.current.date(byAdding: .month, value: -3, to: Date())!)
        case .sixMonth:
            return dateToString(Calendar.current.date(byAdding: .month, value: -6, to: Date())!)
        case .ytd:
            return dateToString(Calendar.current.date(byAdding: .year, value: -1, to: Date())!)
        case .oneYear:
            return dateToString(Calendar.current.date(byAdding: .year, value: -1, to: Date())!)
        case .twoYear:
            return dateToString(Calendar.current.date(byAdding: .year, value: -2, to: Date())!)
        case .threeYear:
            return dateToString(Calendar.current.date(byAdding: .year, value: -3, to: Date())!)
        case .fiveYear:
            return dateToString(Calendar.current.date(byAdding: .year, value: -5, to: Date())!)
        case .tenYear:
            return dateToString(Calendar.current.date(byAdding: .year, value: -10, to: Date())!)
        case .max:
            return dateToString(Calendar.current.date(byAdding: .year, value: -20, to: Date())!)
        }
    }
    
    public var intervalNaver: String {
        switch self {
        case .oneDay: return "minute"
        case .oneWeek: return "minute"
        case .oneMonth, .threeMonth, .sixMonth, .ytd, .oneYear: return "day"
        case .twoYear, .threeYear: return "week"
        case .fiveYear, .tenYear: return "month"
        case .max: return "month"
        }
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: date)
    }

}
