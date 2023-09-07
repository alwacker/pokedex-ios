//
//  APIError.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case let .httpCode(code):
            return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse:
            return "Unexpected response from the server"
        }
    }
}
