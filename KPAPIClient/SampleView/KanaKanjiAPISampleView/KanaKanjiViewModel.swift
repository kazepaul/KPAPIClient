//
//  KanaKanjiModel.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/13.
//

import Foundation
import Combine

class KanaKanjiViewModel: ObservableObject {
    @Published var textToAPI = ""

    @Published var KanaKanjiFormatSelection = 0
    @Published var KanaKanjiModeSelection = 0
    @Published var KanaKanjiOptionSelectedArray:[Bool] = Array(repeating: false, count: KanaKanjiOption.allCases.count)
    @Published var KanaKanjiDictionarySelectedArray:[Bool] = Array(repeating: false, count: KanaKanjiDictionary.allCases.count)
    
    var selectedOptionArray: [KanaKanjiOption] {
        return zip(KanaKanjiOptionSelectedArray, KanaKanjiOption.allCases).filter { $0.0 }.map { $1 }
    }
    
    var selectedDictionaryArray: [KanaKanjiDictionary] {
        return zip(KanaKanjiDictionarySelectedArray, KanaKanjiDictionary.allCases).filter{ $0.0 }.map { $1 }
    }
    
    var isKanaKanjiOptionSelectionEnable: Bool {
        let mode = KanaKanjiMode.allCases[KanaKanjiModeSelection]
        if mode == .roman || mode == .predictive {
            return false
        } else {
            return true
        }
    }
    
    var isKanaKanjiDictionarySelectionEnable: Bool {
        let mode = KanaKanjiMode.allCases[KanaKanjiModeSelection]
        if mode == .roman || mode == .predictive {
            return false
        } else {
            return true
        }
    }
    
    // API Related
    var response: KanaKanjiResponse?
    var error: APIError?
    var resultText: String {
        guard let response = self.response, let result = response.result else {
            return ""
        }
        return result.description
    }
    
    @Published var status = ViewModelStatus.Idle

    var bag = Set<AnyCancellable>()
    
    func fetch(completionHandler: ((Subscribers.Completion<APIError>) -> ())? = nil) {
        status = .Loading
        
        let api = KanaKanjiAPIRequest(text: textToAPI,
                                      format: KanaKanjiFormat.allCases[KanaKanjiFormatSelection],
                                      mode: KanaKanjiMode.allCases[KanaKanjiModeSelection],
                                      option: isKanaKanjiOptionSelectionEnable ? selectedOptionArray : nil,
                                      dictionary: isKanaKanjiDictionarySelectionEnable ? selectedDictionaryArray : nil
                                      , result: 999)
        KPAPISession.shared.request(api: api)
            .flatMap{ response -> Future<KanaKanjiResponse, APIError> in
                Future<KanaKanjiResponse, APIError> { promise in
                    guard let error = response.error else {
                        return promise(.success(response))
                    }
                    promise(.failure(.customError(desc: error.message)))
                }
            }
            .sink { result in
                switch result {
                case .finished:
                    debugPrint("Finish")
                    self.status = .APISuccess
                case .failure(let error):
                    self.error = error
                    self.status = .APIFailure
                }
                completionHandler?(result)
            } receiveValue: { response in
                self.response = response
            }
            .store(in: &bag)
    }
    
    func reset() {
        textToAPI = ""
        KanaKanjiFormatSelection = 0
        KanaKanjiModeSelection = 0
        KanaKanjiOptionSelectedArray = Array(repeating: false, count: KanaKanjiOption.allCases.count)
        KanaKanjiDictionarySelectedArray = Array(repeating: false, count: KanaKanjiDictionary.allCases.count)
    }
}
