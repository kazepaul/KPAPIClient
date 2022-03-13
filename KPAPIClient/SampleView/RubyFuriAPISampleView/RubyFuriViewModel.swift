//
//  RubyFuriModel.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/01/13.
//

import Foundation
import Combine

class RubyFuriViewModel: ObservableObject {
    @Published var gradeSelection = 0
    @Published var textToAPI = ""
    
    // API Related
    var response: RubyFuriResponse?
    var error: APIError?
    @Published var status = ViewModelStatus.Idle
    var resultText: String {
        guard let response = self.response, let result = response.result else {
            return ""
        }
        return result.description
    }

    var bag = Set<AnyCancellable>()
    
    func fetch(completionHandler: ((Subscribers.Completion<APIError>) -> ())? = nil) {
        status = .Loading
        let api = RubyFuriAPIRequest(text: textToAPI, grade: RubyFuriGrade.allCases[gradeSelection].rawValue)
        KPAPISession.shared.request(api: api)
            .flatMap{ response -> Future<RubyFuriResponse, APIError> in
                Future<RubyFuriResponse, APIError> { promise in
                    if response.error != nil {
                        promise(.failure(.customError(desc: "入力された文書は間違いました、もう一度チェックしてください")))
                    } else {
                        promise(.success(response))
                    }
                }
            }
            .sink { result in
                switch result {
                case .finished:
                    self.status = .APISuccess
                case .failure(let error):
                    self.response = nil
                    self.error = error
                    self.status = .APIFailure
                }
                completionHandler?(result)
            } receiveValue: { response in
                self.response = response
                self.error = nil
            }
            .store(in: &bag)
    }
    
    func reset() {
        gradeSelection = 0
        textToAPI = ""
        response = nil
        error = nil
        status = .Idle
    }
}
