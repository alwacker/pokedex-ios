//
//  GenerationsListViewAssembly.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Swinject
import SwinjectAutoregistration

class GenerationsListViewAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(GenerationsListView.self, initializer: GenerationsListView.init)
        container
            .autoregister(GenerationsListViewModel.self, initializer: GenerationsListViewModel.init)
        container
            .autoregister(PokemonsRouter.self, initializer: PokemonsRouter.init)
        container
            .autoregister(PokemonsRouter.GenerationListContext.self, initializer: PokemonsRouter.GenerationListContext.init)
    }
}
