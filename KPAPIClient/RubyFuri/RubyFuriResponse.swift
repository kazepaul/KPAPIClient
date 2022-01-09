//
//  RubyFuriResponse.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/09.
//

import Foundation

struct RubyFuriResponse: Codable, CustomStringConvertible {
    typealias Model = RubyFuriResponse
    
    var id: String
    var jsonrpc: String
    var result: RubyFuriObject?
    
    var description: String {
        var desc = ""
        if let result = result {
            desc.append(result.description)
        }
        return desc
    }
}
