//
//  File.swift
//
//
//  Created by Jongmok Park on 10/19/23.
//

import Foundation

enum QuoteResponse: Decodable {
    case success(SuccessResponse)
    case error(ErrResponse)

    init(from decoder: Decoder) throws {
        // Try to decode as SuccessResponse
        if let successResponse = try? SuccessResponse(from: decoder) {
            self = .success(successResponse)
            return
        }

        // Try to decode as ErrorResponse
        if let errorResponse = try? ErrResponse(from: decoder) {
            self = .error(errorResponse)
            return
        }

        throw DecodingError.dataCorrupted(
            .init(
                codingPath: decoder.codingPath,
                debugDescription: "Data doesn't match any known format")
        )
    }
}

struct SuccessResponse: Decodable {
    let resultCode: String
    let result: ResultData
}

struct ErrResponse: Decodable {
    let timestamp: String
    let status: Int
    let error: String
    let message: String
    let path: String
}

struct ResultData: Decodable {
    let pollingInterval: Int
    let areas: [Area]
    let time: Int64
}

struct Area: Decodable {
    let name: String
    let datas: [Quote]
}

public struct Quote: Decodable {
    
    public let cd: String //code
    public let nm: String? // 회사명
    public let sv: Int? //전일
    public let nv: Int? //현재가
    public let cv: Int? //전일대비  > 0
    public let cr: Double? //등락률 > 0
    public let rf: String?  //? "5"
    public let mt: String? //삼성 "1" 오스템 "2"
    public let ms: String? //"CLOSE"
    public let tyn: String? // "N"
    public let pcv: Int? //전일가
    public let ov: Int? //시가
    public let hv: Int? //고가
    public let lv: Int? //저가
    public let ul: Int? //상한가
    public let ll: Int? //하한가
    public let aq: Int? //거래량
    public let aa: Double? //거래대금
    public let nav: Int? // null
    public let keps: Int?
    public let eps: Int? //eps 원
    public let bps: Double? //bps 원
    public let cnsEps: Int? //Estimated Earnings Per Share? (Projected or analyst's estimated EPS for future, but this is a guess)
    public let dv: Double? //Dividend (금액 in won. Amount paid to shareholders from the company's earnings)
    
    public var id: String {
        cd
    }
    
    public init(cd: String, nm: String? = nil, sv: Int? = nil, nv: Int? = nil, cv: Int? = nil, cr: Double? = nil, rf: String? = nil, mt: String? = nil, ms: String? = nil, tyn: String? = nil, pcv: Int? = nil, ov: Int? = nil, hv: Int? = nil, lv: Int? = nil, ul: Int? = nil, ll: Int? = nil, aq: Int? = nil, aa: Double? = nil, nav: Int? = nil, keps: Int? = nil, eps: Int? = nil, bps: Double? = nil, cnsEps: Int? = nil, dv: Double? = nil) {
        self.cd = cd
        self.nm = nm
        self.sv = sv
        self.nv = nv
        self.cv = cv
        self.cr = cr
        self.rf = rf
        self.mt = mt
        self.ms = ms
        self.tyn = tyn
        self.pcv = pcv
        self.ov = ov
        self.hv = hv
        self.lv = lv
        self.ul = ul
        self.ll = ll
        self.aq = aq
        self.aa = aa
        self.nav = nav
        self.keps = keps
        self.eps = eps
        self.bps = bps
        self.cnsEps = cnsEps
        self.dv = dv
    }
}
