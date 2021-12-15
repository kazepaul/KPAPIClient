//
//  KPAPISession.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/13.
//

import Foundation
import Alamofire

enum APIError: Error {
    case serverError
    case decodeFailure
    case unknown
}

open class KPAPISession {
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    func request<T: KPAPIProtocol>(api: T, completion: @escaping (Result<T.Model, APIError>) -> (Void)) {
        guard let apiURL = api.getAPIRequestURL() else {
            return
        }
        session.request(apiURL,
                        method: api.httpMethod,
                        parameters: api.parameters,
                        encoding: api.encoding,
                        headers: api.headers)
            .responseData { response in
                if let error = response.error {
                    // TODO: Error handling
                    debugPrint("Error: \(error.errorDescription)")
                    completion(.failure(.serverError))
                } else {
                    guard let data = response.data else {
                        debugPrint("Error: No data")
                        completion(.failure(.serverError))
                        return
                    }
                    do {
                        let model = try api.decode(from: data)
                            debugPrint("Success")
                        completion(.success(model))
                    } catch {
                        // TODO: Error handling
                        debugPrint("Error: decode fail")
                        completion(.failure(.decodeFailure))
                    }
                }
            }
    }
}
