//
//  PokemonListViewModel.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Combine
import CombineExt

class PokemonListViewModel: ObservableObject {

    // MARK: - Properties

    // MARK: Inputs

    let didAppear = PassthroughSubject<Void, Never>()

    let loadNextPage = PassthroughSubject<Pokemon, Never>()

    let filterButtonTapped = PassthroughSubject<Void, Never>()

    let pokemonSelected = PassthroughSubject<Pokemon, Never>()

    // MARK: Outputs

    @Published var pokemons: [Pokemon] = []

    @Published var nextPage: String?

    @Published var isPaginationLoading: Bool = false

    // MARK: Private

    private var cancelBag = Set<AnyCancellable>()

    // MARK: - Constructors and destructors

    init(service: PokemonsService, router: PokemonsRouter) {

        pokemonSelected
            .flatMap { router.showPokemonDetail(pokemon: $0) }
            .sink {
                print("Closed")
            }
            .store(in: &cancelBag)


        let selectedFilter = filterButtonTapped
            .flatMap { router.showFilterView() }
            .share()

        let favouritePokemonsFilter = selectedFilter
            .filter { $0 == .favourite }
            .toVoid()
            .map { Storage.instanse.favouritePokemons }
            .flatMap { service.getPokemonList(results: $0, getResultWithName: true) }
            .data()
            .share()

        favouritePokemonsFilter
            .receive(on: DispatchQueue.main)
            .assertNoFailure()
            .sink { [weak self] data in
                self?.nextPage = nil
                self?.pokemons = data
            }
            .store(in: &cancelBag)

        let generationFilterRequest = selectedFilter
            .filter { $0 == .allGen }
            .toVoid()
            .flatMap { router.showGenerationFilter() }
            .flatMap { service.getPokemonList(results: $0, getResultWithName: true) }
            .data()
            .share()

        let allTypesFilter = selectedFilter
            .filter { $0 == .allTypes }
            .toVoid()
            .share()

        Publishers.Merge(allTypesFilter, generationFilterRequest.assertNoFailure().toVoid())
            .map(to: [])
            .assign(to: &$pokemons)

        let loadFirstPage = Publishers.Merge(didAppear, allTypesFilter)
            .flatMap { service.getFirstPage() }
            .share()

        generationFilterRequest
            .receive(on: DispatchQueue.main)
            .assertNoFailure()
            .sink { [weak self] data in
                self?.nextPage = nil
                self?.pokemons = data
            }
            .store(in: &cancelBag)

        loadFirstPage
            .data()
            .map { $0.next }
            .assertNoFailure()
            .assign(to: &$nextPage)

        loadFirstPage
            .data()
            .map { $0.results.map { $0.url } }
            .flatMap { service.getPokemonList(results: $0) }
            .data()
            .assertNoFailure()
            .assign(to: &$pokemons)

        let canLoadNextPage = loadNextPage
            .map { [weak self] in self?.loadMoreContent(currentItem: $0) }
            .unwrap()
            .filter { $0 }
            .share()

        canLoadNextPage
            .assign(to: &$isPaginationLoading)

        let nextPageRequest = canLoadNextPage
            .withLatestFrom($nextPage)
            .unwrap()
            .flatMap { service.getNextPage(url: $0) }
            .share()

        nextPageRequest
            .data()
            .map { $0.next }
            .assertNoFailure()
            .assign(to: &$nextPage)

        nextPageRequest
            .data()
            .map { $0.results.map { $0.url } }
            .flatMap { service.getPokemonList(results: $0) }
            .data()
            .assertNoFailure()
            .sink { [weak self] in
                self?.pokemons += $0
                self?.isPaginationLoading = false
            }
            .store(in: &cancelBag)
    }

    private func loadMoreContent(currentItem item: Pokemon) -> Bool {
        guard !pokemons.isEmpty else { return false}
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -1)
        if pokemons[thresholdIndex].id == item.id, nextPage != nil {
            return true
        }
        return false
    }
}
