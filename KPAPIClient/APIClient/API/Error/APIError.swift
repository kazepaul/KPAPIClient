//
//  APIError.swift
//  KPAPIClient
//
//  Created by Chan, Paul | Paul on 2022/03/13.
//

import Foundation

enum APIError: Error, CustomStringConvertible  {
    case invalidURL
    case serverError
    case decodeFailure
    case customError(desc: String)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "URLは正しくありません"
        case .serverError:
            return "サーバーエラーが起こりました"
        case .decodeFailure:
            return "サーバーエラーが起こりました"
        case .customError(let desc):
            return desc
        }
    }
}
