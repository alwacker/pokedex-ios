//
//  FilterViewAssembly.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Swinject
import SwinjectAutoregistration

class FilterViewAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(FilterViewModel.self, initializer: FilterViewModel.init)
        container
            .autoregister(FilterView.self, initializer: FilterView.init)
        container
            .autoregister(PokemonsRouter.self, initializer: PokemonsRouter.init)
        container
            .autoregister(PokemonsRouter.FilterContext.self, initializer: PokemonsRouter.FilterContext.init)
    }
}
