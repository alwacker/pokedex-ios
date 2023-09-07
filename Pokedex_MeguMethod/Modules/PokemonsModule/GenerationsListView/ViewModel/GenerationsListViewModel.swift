//
//  GenerationsListViewModel.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Combine

class GenerationsListViewModel: ObservableObject {
    // MARK: - Properties

    // MARK: Inputs

    let didAppear = PassthroughSubject<Void, Never>()

    let generationSelected = PassthroughSubject<GenerationDTO, Never>()

    // MARK: Outputs

    @Published var generations: [GenerationDTO] = []

    // MARK: Private

    private var cancelBag = Set<AnyCancellable>()

    // MARK: - Constructors and destructors

    init(service: PokemonsService, context: PokemonsRouter.GenerationListContext) {
        didAppear
            .flatMap { service.getGenerations() }
            .data()
            .flatMap { service.getGenerationsDetail(results: $0.results) }
            .data()
            .flatMap { service.getGenerationsDTO(generations: $0) }
            .data()
            .sink { error in
                print(error)

            } receiveValue: { [weak self] data in
                self?.generations = data
            }
            .store(in: &cancelBag)

        generationSelected
            .map { $0.generation.species.map { $0.name } }
            .sink {
                context.generationSelected.send($0)
            }
            .store(in: &cancelBag)
    }
}
