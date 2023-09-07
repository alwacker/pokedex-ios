//
//  APIEvent.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation

enum APIEvent<T> {
    case loading
    case loaded(T)
    case error(Error)

    public var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }

    public var isLoading: Bool {
        if case .loading = self {
            return true

        } else {
            return false
        }
    }

    public var isError: Bool {
        if case .error = self {
            return true

        } else {
            return false
        }
    }

    var loaded: T? {
        guard case .loaded(let value) = self else { return nil }
        return value
    }

    var error: Error? {
        guard case .error(let value) = self else { return nil }
        return value
    }
}
