//
//  BaseAPI.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]
typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

class BaseApi {
    private let base: ApiGateway

    init(base: ApiGateway) {
        self.base = base
    }

    public init(baseUrl: String) {
        self.base = ApiGateway(baseUrl: baseUrl)
    }

    func getEndpointUrl(endPoint: String) -> String {
        return base.getEndpointURL(endPoint: endPoint)
    }

    func request<T:Decodable>(
        endPoint: APIEndpoint,
        method: APIMethod = .get,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<APIEvent<T>, Error> {
        return ApiProvider.instance.request(endPoint: getEndpointUrl(endPoint: endPoint.rawValue), method: method, params: params, headers: headers)
    }

    func request<T:Decodable>(
        endPoint: String,
        method: APIMethod = .get,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<APIEvent<T>, Error> {
        return ApiProvider.instance.request(endPoint: endPoint, method: method, params: params, headers: headers)
    }
}
