//
//  RubyFuriAPIRequest.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/09.
//

import Foundation
import Alamofire

enum RubyFuriGrade: Int, CustomStringConvertible, CaseIterable {
    case grade0
    case grade1
    case grade2
    case grade3
    case grade4
    case grade5
    case grade6
    case grade7
    case grade8
    
    var gradeTitle: String {
        switch self {
        case .grade0:
            return "無指定"
        default:
            return "\(self.rawValue)"
        }
    }
    
    var description: String {
        switch self {
        case .grade0:
            return "ひらがなを含むテキストにふりがなを付けます。"
        case .grade1:
            return "小学1年生向け。漢字にふりがなを付けます。"
        case .grade2:
            return "小学2年生向け。1年生で習う漢字にはふりがなを付けません。"
        case .grade3:
            return "小学3年生向け。1～2年生で習う漢字にはふりがを付けません。"
        case .grade4:
            return "小学4年生向け。1～3年生で習う漢字にはふりがなを付けません。"
        case .grade5:
            return "小学5年生向け。1～4年生で習う漢字にはふりがなを付けません。"
        case .grade6:
            return "小学6年生向け。1～5年生で習う漢字にはふりがなを付けません。"
        case .grade7:
            return "中学生以上向け。小学校で習う漢字にはふりがなを付けません。"
        case .grade8:
            return "一般向け。常用漢字にはふりがなを付けません。"
        }
    }
}

struct RubyFuriAPIRequest: KPAPIProtocol {
    typealias Model = RubyFuriResponse

    let q: String
    var grade: Int?
    
    var baseURL: String {
        return YahooAPIConstraint.baseURL
    }
    
    var path: String {
        return "FuriganaService/V2/furigana"
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json",
                "User-Agent": "Yahoo AppID:\(YahooAPIConstraint.appid)"]
    }
        
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var parameters: [String : Any] {
        var requestParams:[String: Any] = ["appid": YahooAPIConstraint.appid,
                                           "id": "aaaa",
                                           "jsonrpc": "2.0",
                                           "method": "jlp.furiganaservice.furigana"]
        
        var params:[String: Any] = ["q": q];
        
        if let grade = self.grade {
            params["grade"] = grade
        }
        
        requestParams["params"] = params
        return requestParams
    }
    
    init(text: String, grade: Int) {
        self.q = text
        self.grade = grade
    }
}
