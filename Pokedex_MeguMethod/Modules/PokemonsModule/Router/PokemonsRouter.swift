//
//  PokemonsRouter.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine
import Swinject
import SwiftUI

class PokemonsRouter {

    private let transitionHandler: TransitionHandler

    private let assembler: Assembler

    init(transitionHandler: TransitionHandler, assembler: Assembler) {
        self.transitionHandler = transitionHandler
        self.assembler = assembler.with(assemblies: PokemonsModuleAssembly())
    }

    class FilterContext {
        let filterTypeSelected = PassthroughSubject<FilterItemDTO.FilterType, Never>()
        let closeFilterPressed = PassthroughSubject<Void, Never>()
    }

    func showFilterView() -> AnyPublisher<FilterItemDTO.FilterType, Never> {
        let context = FilterContext()
        let view = assembler
            .with(assemblies: FilterViewAssembly())
            .with(globals: context)
            .resolver
            .resolve(FilterView.self)!

        let vc = UIHostingController(rootView: view)
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = .clear

        if let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window {
            window.rootViewController?.present(vc, animated: false)
        }

        var cancelBag = Set<AnyCancellable>()

        return AnyPublisher.create { [weak vc] subscriber in
            context.filterTypeSelected.sink { filter in
                vc?.dismiss(animated: false) {
                    subscriber.send(filter)
                    subscriber.send(completion: .finished)
                }
            }.store(in: &cancelBag)

            context.closeFilterPressed.sink {
                vc?.dismiss(animated: false) {
                    subscriber.send(completion: .finished)
                }
            }.store(in: &cancelBag)

            return AnyCancellable {
                cancelBag.forEach { $0.cancel() }
            }
        }
    }

    class GenerationListContext {
        let generationSelected = PassthroughSubject<[String], Never>()
    }

    func showGenerationFilter() -> AnyPublisher<[String], Never> {
        let context = GenerationListContext()
        let view = assembler
            .with(assemblies: GenerationsListViewAssembly())
            .with(globals: context)
            .resolver
            .resolve(GenerationsListView.self)!

        let hostingController = UIHostingController(rootView: view)

        let vc = NavigationViewController(rootViewController: hostingController)

        vc.modalPresentationStyle = .pageSheet
        vc.navigationBar.prefersLargeTitles = true
        transitionHandler.modal(controller: vc, animated: true)

        var cancelBag = Set<AnyCancellable>()

        return AnyPublisher.create { [weak vc] subscriber in
            context.generationSelected.sink { items in
                vc?.dismiss(animated: true) {
                    subscriber.send(items)
                    subscriber.send(completion: .finished)
                }
            }.store(in: &cancelBag)

            return AnyCancellable {
                cancelBag.forEach { $0.cancel() }
            }
        }

    }

    class PokemonDetailContext {
        let backButtonPressed = PassthroughSubject<Void, Never>()
    }

    func showPokemonDetail(pokemon: Pokemon) -> AnyPublisher<Void, Never> {
        let context = PokemonDetailContext()
        let view = assembler
            .with(assemblies: PokemonDetailViewAssembly())
            .with(globals: context, pokemon)
            .resolver
            .resolve(PokemonDetailView.self)!

        let hostingController = UIHostingController(rootView: view)

        guard let delegate = UIApplication.shared.delegate as? AppDelegate,
           let navController = delegate.window?.rootViewController as? NavigationViewController else {
            return AnyPublisher<Void, Never>.create { _ in
                return AnyCancellable {}
            }
        }

        navController.setUpNavigationBar(backgroundColor: pokemon.types.first?.type.kind.color(), titleColor: .white)

        hostingController.navigationItem.hidesBackButton = true

        transitionHandler.push(controller: hostingController, animated: true)

        var cancelBag = Set<AnyCancellable>()

        return AnyPublisher.create { [weak hostingController] subscriber in
            context.backButtonPressed.sink { items in
                hostingController?.navigationController?.popToRootViewController(animated: true)
                navController.setUpNavigationBar()
                subscriber.send(())
                subscriber.send(completion: .finished)
            }.store(in: &cancelBag)

            return AnyCancellable {
                cancelBag.forEach { $0.cancel() }
            }
        }
    }
}
