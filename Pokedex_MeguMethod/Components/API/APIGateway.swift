//
//  APIGateway.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation

protocol Gateway {
    func getEndpointURL(endPoint: String) -> String
}

class ApiGateway: Gateway {
    private let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func getEndpointURL(endPoint: String) -> String {
        return prepareUrl(endPoint: endPoint)
    }

    func prepareUrl(endPoint: String) -> String {
        return "\(baseUrl)\(endPoint)"
    }
}
