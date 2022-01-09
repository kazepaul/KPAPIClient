//
//  KanaKanjiResponse.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/14.
//

import Foundation

struct KanaKanjiResponse: Codable, CustomStringConvertible {
    typealias Model = KanaKanjiResponse
    
    var id: String
    var jsonrpc: String
    var result: [String: [KanaKanjiObject]]?
    
    var description: String {
        var desc = ""
        if let result = self.result, let kanaKanjiObjArr = result["segment"] {
            for kkObj in kanaKanjiObjArr {
                desc += kkObj.description + "\n"
            }
        }
        return desc
    }
}
