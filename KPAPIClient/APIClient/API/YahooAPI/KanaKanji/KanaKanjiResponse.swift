//
//  KanaKanjiResponse.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/14.
//

import Foundation

struct KanaKanjiResponseError: Codable {
    let code: Int
    let message: String
}

struct KanaKanjiResponse: Codable, CustomStringConvertible {
    typealias Model = KanaKanjiResponse
    
    let id: String
    let jsonrpc: String
    var result: KanaKanjiObject?
    var error: KanaKanjiResponseError?

    var description: String {
        var desc = ""
        if let result = result {
            desc = result.description
        } else if let error = error {
            desc = error.message
        }
        return desc
    }
}
