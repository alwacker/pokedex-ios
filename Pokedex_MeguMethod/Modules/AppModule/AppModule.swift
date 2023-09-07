//
//  AppModule.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject

class AppModule: Module {
    internal let assembler: Assembler

    required init(assembler: Assembler) {
        self.assembler = assembler
            .with(globals: Bundle.main)
    }

    lazy var router: AppRouter = {
        return self.assembler
            .with(assemblies: AppRouterAssembly())
            .resolver
            .resolve(AppRouter.self)!
    }()
}

