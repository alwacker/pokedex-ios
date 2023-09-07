//
//  AppRouter.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject
import UIKit

class AppRouter {
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    private func getWeatherModule() -> UIViewController {
        let module = resolver.resolve(PokemonsModule.self)!
        return module.showPokemomList(with: self)
    }

    public func initialize() -> UIViewController {
        return getWeatherModule()
    }
}
