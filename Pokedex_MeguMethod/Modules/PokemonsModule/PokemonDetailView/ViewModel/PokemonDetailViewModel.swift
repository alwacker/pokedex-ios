//
//  PokemonDetailViewModel.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Combine

class PokemonDetailViewModel: ObservableObject {

    typealias PokemonDetailDTO = (pokemon: Pokemon, pokemonDetail: PokemonDetail)

    // MARK: - Properties

    // MARK: Inputs

    let didAppear = PassthroughSubject<Void, Never>()

    let likeButtonPressed = PassthroughSubject<Void, Never>()

    let backButtonPressed = PassthroughSubject<Void, Never>()

    // MARK: Outputs

    @Published var pokemonDetail: PokemonDetailDTO?

    @Published var isFavourite: Bool = false

    // MARK: Private

    private var cancelBag = Set<AnyCancellable>()

    // MARK: - Constructors and destructors

    init(pokemon: Pokemon, service: PokemonsService, context: PokemonsRouter.PokemonDetailContext) {

        didAppear
            .map(to: Storage.instanse.favouritePokemons)
            .map { $0.contains(pokemon.name) }
            .assign(to: &$isFavourite)

        likeButtonPressed
            .sink { [weak self] in
                if Storage.instanse.favouritePokemons.contains(pokemon.name) {
                    var newValue = Storage.instanse.favouritePokemons
                    newValue.removeAll { $0 == pokemon.name }
                    Storage.instanse.favouritePokemons = newValue
                    self?.isFavourite = false

                } else {
                    var newValue = Storage.instanse.favouritePokemons
                    newValue.append(pokemon.name)
                    Storage.instanse.favouritePokemons = newValue
                    self?.isFavourite = true
                }
            }
            .store(in: &cancelBag)

        service.getPokemonDetail(id: pokemon.id)
            .data()
            .assertNoFailure()
            .sink { [weak self] in
                self?.pokemonDetail = PokemonDetailDTO(pokemon, $0)
            }
            .store(in: &cancelBag)

        backButtonPressed
            .sink {
                context.backButtonPressed.send()
            }
            .store(in: &cancelBag)
    }
}
