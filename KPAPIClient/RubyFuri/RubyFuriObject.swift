//
//  RubyFuriObject.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/09.
//

import Foundation

struct RubyFuriObject: Codable, CustomStringConvertible {
    var word:[RubyFuriWordObject]
    
    var description: String {
        var desc = ""
        word.forEach {
            desc.append("\($0)\n")
        }
        return desc
    }
}

struct RubyFuriWordObject: Codable, CustomStringConvertible {
    var surface: String
    var furigana: String?
    var roman: String?
    var subword: [RubyFuriWordObject]?
    
    var description: String {
        var desc = "表記: \(surface)\n"
        if let furigana = furigana {
            desc.append("ふりがな: \(furigana)\n")
        }
        if let roman = roman {
            desc.append("ローマ字: \(roman)\n")
        }
        if let subword = subword {
            desc.append("細かく:\n")
            subword.forEach {
                desc.append("\($0)\n")
            }
        }
        
        return desc
    }
}
