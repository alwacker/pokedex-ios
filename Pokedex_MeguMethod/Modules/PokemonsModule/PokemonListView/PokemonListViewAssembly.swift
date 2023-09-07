//
//  PokemonListViewAssembly.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject
import SwinjectAutoregistration

class PokemonListViewAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(PokemonListViewModel.self, initializer: PokemonListViewModel.init)
        container
            .autoregister(PokemonListView.self, initializer: PokemonListView.init)
        container
            .autoregister(PokemonsRouter.self, initializer: PokemonsRouter.init)
    }
}
