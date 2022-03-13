//
//  KPAPISession.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/13.
//

import Foundation
import Alamofire
import Combine

open class KPAPISession {
    static let shared = KPAPISession()
    
    func request<T: KPAPIProtocol>(api: T) -> AnyPublisher<T.Model, APIError> {
        guard let apiURL = api.getAPIRequestURL() else {
            return Future<T.Model, APIError> { promise in
                promise(.failure(.invalidURL))
            }.eraseToAnyPublisher()
        }
        return AF.request(apiURL,
                          method: api.httpMethod,
                          parameters: api.parameters,
                          encoding: api.encoding,
                          headers: api.headers)
            .publishDecodable(type: T.Model.self, queue: DispatchQueue.main)
            .setFailureType(to: APIError.self)
            .mapError{ error -> APIError in
                return APIError.serverError
            }
            .flatMap { response -> Future<T.Model, APIError> in
                return Future<T.Model, APIError> { promise in
                    guard response.data != nil else {
                        promise(.failure(.serverError))
                        return
                    }
                    guard let model = response.value else {
                        promise(.failure(.decodeFailure))
                        return
                    }
                    promise(.success(model))
                }
            }.eraseToAnyPublisher()
    }
}
