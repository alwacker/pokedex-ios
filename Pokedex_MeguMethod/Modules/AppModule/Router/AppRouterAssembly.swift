//
//  AppRouterAssembly.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Swinject
import SwinjectAutoregistration

class AppRouterAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(AppRouter.self, initializer: AppRouter.init)
            .inObjectScope(.container)
    }
}
