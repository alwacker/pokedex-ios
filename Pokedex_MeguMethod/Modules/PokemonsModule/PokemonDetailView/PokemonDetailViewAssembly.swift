//
//  PokemonDetailViewAssembly.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Swinject
import SwinjectAutoregistration

class PokemonDetailViewAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(PokemonDetailView.self, initializer: PokemonDetailView.init)
        container
            .autoregister(PokemonDetailViewModel.self, initializer: PokemonDetailViewModel.init)
        container
            .autoregister(PokemonsRouter.self, initializer: PokemonsRouter.init)
        container
            .autoregister(PokemonsRouter.PokemonDetailContext.self, initializer: PokemonsRouter.PokemonDetailContext.init)
    }
}
