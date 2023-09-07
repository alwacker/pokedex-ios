//
//  PokemonsModuleAssembly.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject
import SwinjectAutoregistration

class PokemonsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(PokemonsAPI.self, initializer: PokemonsAPI.init(base:))
        container
            .autoregister(PokemonsService.self, initializer: PokemonsService.init)
    }
}
