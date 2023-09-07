//
//  CombineExtensions.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        self
    }
}

extension Publisher where Output: OptionalType {

    func unwrap() -> Publishers.CompactMap<Self, Output.Wrapped> {
        compactMap { $0.value }
    }
}

extension Publisher {

    func map<T>(to value: T) -> Publishers.Map<Self, T> {
        map { _ in value }
    }

    func toVoid() -> Publishers.Map<Self, Void> {
        map(to: ())
    }
}

public enum FilterMap<Result> {
    case ignore
    case map(Result)
}

extension Publisher {
    /**
     Filters or Maps values from the source.
     - The returned Publisher will complete with the source. It will error with the source or with error thrown by transform callback.
     - `next` values will be output according to the `transform` callback result:
        - returning `.ignore` will filter the value out of the returned Publishers
        - returning `.map(newValue)` will propagate newValue through the returned Publishers.
     */

    public func filterMap<Result>(_ transform: @escaping (Self.Output) throws -> FilterMap<Result>) -> Publishers.CompactMap<Self, Result> {
        return compactMap { element in
            do {
                switch try transform(element) {
                case .ignore:
                    return nil

                case let .map(result):
                    return result
                }

            } catch {
                return nil
            }
        }
    }
}
