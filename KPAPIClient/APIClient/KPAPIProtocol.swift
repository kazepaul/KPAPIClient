//
//  KPAPIProtocol.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2021/12/13.
//

import Foundation
import Alamofire

protocol KPAPIProtocol {
    associatedtype Model: Codable
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    func decode(from data: Data) throws -> Model
}

extension KPAPIProtocol {
    func getAPIRequestURL() -> URL? {
        return URL(string: baseURL)?.appendingPathComponent(path)
    }
    
    func decode(from data: Data) throws -> Model {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Model.self, from: data)
    }
}
