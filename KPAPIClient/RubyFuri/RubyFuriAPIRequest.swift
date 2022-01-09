//
//  RubyFuriAPIRequest.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/09.
//

import Foundation
import Alamofire

fileprivate let appid = "dj00aiZpPXdYRDUyT0dJeWd3VSZzPWNvbnN1bWVyc2VjcmV0Jng9YmM-"

struct RubyFuriAPIRequest: KPAPIProtocol {
    typealias Model = RubyFuriResponse

    let q: String
    var grade: Int?
    
    var baseURL: String {
        return "https://jlp.yahooapis.jp/"
    }
    
    var path: String {
        return "FuriganaService/V2/furigana"
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json",
                "User-Agent": "Yahoo AppID:\(appid)"]
    }
        
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var parameters: [String : Any] {
        var requestParams:[String: Any] = ["appid": appid,
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
