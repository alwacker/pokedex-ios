//
//  AppContainer.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject
import SwinjectAutoregistration

class AppContainer {
    static let instance = AppContainer()
    let container = Container()

    init() {
        container.register(Resolver.self) { resolver in
            return resolver
        }

        container.register(Gateway.self) { resolver in
            return resolver.resolve(Gateway.self)!
        }

        container.register(ApiGateway.self) { resolver in
            return ApiGateway(baseUrl: "https://pokeapi.co/api/v2/")
        }
    }
}
