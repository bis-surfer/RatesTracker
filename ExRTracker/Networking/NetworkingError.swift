//
//  NetworkingError.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 31.03.2025.
//

import Foundation

enum NetworkingError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unexpected(Error)
}

extension NetworkingError {
    var message: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL error"
        case .invalidResponse:
            return "Invalid response error"
        case .invalidData:
            return "Invalid data error"
        case let .unexpected(error):
            return "Unexpected error: \(error)"
        }
    }
}
