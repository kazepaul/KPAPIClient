//
//  KanaKanjiAPIRequest.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/14.
//

import Foundation
import Alamofire

fileprivate let appid = "dj00aiZpPXdYRDUyT0dJeWd3VSZzPWNvbnN1bWVyc2VjcmV0Jng9YmM-"

enum KanaKanjiFormat: String, CustomStringConvertible, CaseIterable {
    case hiragana
    case roman
    
    var title: String {
        switch self {
        case .hiragana:
            return "ひらがな"
        case .roman:
            return "ローマ字"
        }
    }
    
    var description: String {
        switch self {
        case .hiragana:
            return "かな漢字変換の対象となるテキストはひらがなのみとなります"
        case .roman:
            return "リクエストされたテキスト情報中のひらがなと半角英小文字が変換対象となります"
        }
    }
}

enum KanaKanjiMode: String, CustomStringConvertible, CaseIterable {
    case kanakanji
    case roman
    case predictive
    
    var description: String {
        switch self {
        case .kanakanji:
            return "通常の変換候補を返す通常変換を行います"
        case .roman:
            return "ローマ字からひらがなに変換した結果のみを返すローマ字変換を行います"
        case .predictive:
            return "推測変換の候補を返します"
        }
    }
}

enum KanaKanjiOption: String, CustomStringConvertible, CaseIterable {
    case hiragana
    case katakana
    case alphanumeric
    case half_katakana
    case half_alphanumeric
    
    var title: String {
        switch self {
        case .hiragana:
            return "全角ひらがな"
        case .katakana:
            return "全角カタカナ"
        case .alphanumeric:
            return "英数字"
        case .half_katakana:
            return "半角カタカナ"
        case .half_alphanumeric:
            return "半角英数字"
        }
    }
    
    var description: String {
        switch self {
        case .hiragana:
            return "全角ひらがな変換の内容をHiraganaに返します"
        case .katakana:
            return "全角カタカナ変換の内容をKatakanaに返します"
        case .alphanumeric:
            return "全角英数字変換の内容をAlphanumericに返します"
        case .half_katakana:
            return "半角カタカナ変換の内容をHalfKatakanaに返します"
        case .half_alphanumeric:
            return "半角英数字変換の内容をHalfAlphanumericに返します"
        }
    }
}

enum KanaKanjiDictionary: String, CustomStringConvertible, CaseIterable {
    case base
    case name
    case place
    case zip
    case symbol
    
    var title: String {
        switch self {
        case .base:
            return "一般"
        case .name:
            return "人名"
        case .place:
            return "地名"
        case .zip:
            return "郵便番号"
        case .symbol:
            return "顔文字、記号"
        }
    }
    
    var description: String {
        switch self {
        case .base:
            return "一般辞書の候補を返します"
        case .name:
            return "人名辞書の候補を返します"
        case .place:
            return "地名辞書の候補を返します"
        case .zip:
            return "郵便番号辞書の候補を返します"
        case .symbol:
            return "顔文字、記号辞書の候補を返します"
        }
    }
}

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
    
    init(text q: String, format: KanaKanjiFormat? = nil, mode: KanaKanjiMode? = nil, option: [KanaKanjiOption]? = nil, dictionary: [KanaKanjiDictionary]? = nil, result: Int? = nil) {
        self.q = q
        self.format = format?.rawValue
        self.mode = mode?.rawValue
        self.option = option?.map{ $0.rawValue }
        self.dictionary = dictionary?.map { $0.rawValue }
        self.result = result
    }
}
