import UIKit
import SwiftUI
import Alamofire

let session = KPAPISession(session: Session.default)

// かな漢字変換
session.request(api: KanaKanjiAPIRequest(text: "きょうはよいてんきです。",
                                         format: "hiragana",
                                         mode: "kanakanji",
                                         option: ["hiragana", "katakana", "alphanumeric", "half_katakana", "half_alphanumeric"],
                                         dictionary: ["base", "name", "place", "zip", "symbol"],
                                         result: 999)) { result in
    switch result {
        case let .success(model):
            print(model.description)
        case let .failure(error):
            print(error)
    }
}

// ルビ振り
session.request(api: RubyFuriAPIRequest(text: "漢字かな交じり文にふりがなを振ること。",
                                        grade: 5)) { result in
    switch result {
        case let .success(model):
            print(model.description)
        case let .failure(error):
            print(error)
    }
}
