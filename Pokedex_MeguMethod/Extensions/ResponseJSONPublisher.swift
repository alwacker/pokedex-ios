//
//  ResponseJSONPublisher.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<T: Decodable>(httpCodes: HTTPCodes) -> AnyPublisher<T, Error> {
        tryMap {
            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                throw ApiError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw ApiError.httpCode(code)
            }
            return $0.0
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
