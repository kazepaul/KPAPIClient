//
//  KanaKanjiObject.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/14.
//

import Foundation

struct KanaKanjiObject: Codable, CustomStringConvertible {
    var reading: String?
    var hiragana: String?
    var katakana: String?
    var alphanumeric: String?
    var half_katakana: String?
    var half_alphanumeric: String?
    var candidate: [String]?
    
    var description: String {
        var desc = ""
        if let reading = self.reading {
            desc += "読み: \(reading)\n"
        }
        if let hiragana = self.hiragana {
            desc += "全角ひらがな: \(hiragana)\n"
        }
        if let katakana = self.katakana {
            desc += "全角カタカナ: \(katakana)\n"
        }
        if let alphanumeric = self.alphanumeric {
            desc += "全角英数字: \(alphanumeric)\n"
        }
        if let half_katakana = self.half_katakana {
            desc += "半角カタカナ: \(half_katakana)\n"
        }
        if let half_alphanumeric = self.half_alphanumeric {
            desc += "半角英数字: \(half_alphanumeric)\n"
        }
        if let candidate = self.candidate {
            desc += "変換候補: \(candidate)\n"
        }
        
        return desc
    }
}
