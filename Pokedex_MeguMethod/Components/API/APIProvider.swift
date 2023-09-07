//
//  APIProvider.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine
import CombineExt

enum APIMethod: String {
    case get     = "GET"
    case post    = "POST"
}

class ApiProvider {
    static let instance = ApiProvider()

    private let logQueue = DispatchQueue(label: "com.Pokedex.api-log", qos: .background)

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()

    private func log(message: String) {
        logQueue.async {
            print(message)
        }
    }

    func request<T: Decodable>(
        endPoint: String,
        method: APIMethod = .get,
        params: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        httpCodes: HTTPCodes = .success
    ) -> AnyPublisher<APIEvent<T>, Error> {
        return AnyPublisher<APIEvent<T>, Error>.create { [weak self] subscriber in
            subscriber.send(.loading)

            let request = try? self?.createRequest(endPoint, method: method, parameters: params, headers: headers)
            var cancellable: AnyCancellable?

            guard let request = request else {
                subscriber.send(.error(ApiError.unexpectedResponse))
                subscriber.send(completion: .finished)
                return AnyCancellable {
                    cancellable?.cancel()
                }
            }

            cancellable = self?.session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        subscriber.send(completion: .finished)

                    case let .failure(error):
                        subscriber.send(.error(error))
                        subscriber.send(completion: .finished)
                    }

                }, receiveValue: { (responseData: T) in
                    subscriber.send(.loaded(responseData))
                    subscriber.send(completion: .finished)
                })

            return AnyCancellable {
                cancellable?.cancel()
            }
        }
    }

    private func createRequest(
        _ url: String,
        method: APIMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) throws -> URLRequest {
        let debugString = "DEBUG: - ApiProvider: create request to \(url), method \(method), params: \(String(describing: parameters))"
        self.log(message: debugString)
        guard let url = URL(string: url) else {
            throw ApiError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let params = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        return request
    }
}
