//
//  PokemonsModule.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject
import SwiftUI

class PokemonsModule: Module {
    private let assembler: Assembler

    required init(assembler: Assembler) {
        self.assembler = assembler.with(assemblies: PokemonsModuleAssembly())
    }

    func showPokemomList(with transitionHandler: TransitionHandler) -> UIViewController {
        let view = assembler
            .with(assemblies: PokemonListViewAssembly())
            .with(globals: transitionHandler)
            .resolver
            .resolve(PokemonListView.self)!

        let vc = UIHostingController(rootView: view)
        let root = NavigationViewController(rootViewController: vc)
        root.setUpNavigationBar()
        return root
    }
}
