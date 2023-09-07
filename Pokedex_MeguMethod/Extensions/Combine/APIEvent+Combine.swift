//
//  APIEvent+Combine.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Combine

protocol APIEventConvertible {
    associatedtype Data
    var value: APIEvent<Data> { get }
}

extension APIEvent: APIEventConvertible {
    public typealias Data = T
    public var value: APIEvent<Data> { return self }
}

extension Publisher where Output: APIEventConvertible, Output.Data: Any {

    func isLoading() -> AnyPublisher<Bool, Failure> {
        return self.map { $0.value.isLoading ? true : false }.eraseToAnyPublisher()
    }

    func errors() -> AnyPublisher<Error, Failure> {
        return map { $0.value.error }.unwrap().eraseToAnyPublisher()
    }

    func elements(onErrorJustReturn: Output.Data? = nil) -> AnyPublisher<Output.Data, Failure> {
        return map { event -> Output.Data? in
            if event.value.isError, let value = onErrorJustReturn {
                return value

            } else {
                return event.value.loaded
            }
        }
        .unwrap()
        .eraseToAnyPublisher()
    }

    func data() -> AnyPublisher<Output.Data, Failure> {
        return elements()
    }
}
