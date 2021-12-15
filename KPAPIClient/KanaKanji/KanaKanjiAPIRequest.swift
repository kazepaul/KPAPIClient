//
//  KanaKanjiAPIRequest.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/14.
//

import Foundation
import Alamofire

fileprivate let appid = "dj00aiZpPXdYRDUyT0dJeWd3VSZzPWNvbnN1bWVyc2VjcmV0Jng9YmM-"

struct KanaKanjiAPIRequest: KPAPIProtocol {
    typealias Model = KanaKanjiResponse
    
    let q: String
    var format: String?
    var mode: String?
    var option: [String]?
    var dictionary: [String]?
    var result: Int?
    
    var baseURL: String {
        return "https://jlp.yahooapis.jp/"
    }
    
    var path: String {
        return "JIMService/V2/conversion"
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
    
    var parameters: [String: Any] {
        var requestParams:[String: Any] = ["appid": appid,
                                           "id": "aaaa",
                                           "jsonrpc": "2.0",
                                           "method": "jlp.jimservice.conversion"]
        
        var params:[String: Any] = ["q": q];
        
        if let format = self.format {
            params["format"] = format
        }
        if let mode = self.mode {
            params["mode"] = mode
        }
        if let option = self.option {
            params["option"] = option
        }
        if let dictionary = self.dictionary {
            params["dictionary"] = dictionary
        }
        if let result = self.result {
            params["result"] = result
        }
        
        requestParams["params"] = params
        return requestParams
    }
    
    init(text q: String, format: String? = nil, mode: String? = nil, option: [String]? = nil, dictionary: [String]? = nil, result: Int? = nil) {
        self.q = q
        self.format = format
        self.mode = mode
        self.option = option
        self.dictionary = dictionary
        self.result = result
    }
}
