//
//  PokemonsService.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine
import CombineExt

class PokemonsService {

    private let api: PokemonsAPI

    init(api: PokemonsAPI) {
        self.api = api
    }

    func getFirstPage() -> AnyPublisher<APIEvent<PokemonPage>, Error> {
        return api.getFirstPage()
    }

    func getNextPage(url: String) -> AnyPublisher<APIEvent<PokemonPage>, Error> {
        return api.getNextPage(url: url)
    }

    func getPokemonList(results: [String], getResultWithName: Bool = false) -> AnyPublisher<APIEvent<[Pokemon]>, Error> {
        return AnyPublisher<APIEvent<[Pokemon]>, Error>.create { [weak self] subscriber in
            guard let self else { return AnyCancellable { } }
            var cancellable: AnyCancellable
            subscriber.send(.loading)

            cancellable = results
                .map { getResultWithName ? self.api.getPokemonObject(name: $0) : self.api.getPokemonObject(url: $0) }
                .publisher
                .flatMap { $0.data() }
                .collect()
                .sink { completion in
                    switch completion {
                    case .finished:
                        subscriber.send(completion: .finished)

                    case let .failure(error):
                        subscriber.send(.error(error))
                    }

                } receiveValue: { data in
                    let sortedData = data.sorted { $0.id < $1.id }
                    subscriber.send(.loaded(sortedData))
                    subscriber.send(completion: .finished)
                }

            return AnyCancellable {
                cancellable.cancel()
            }
        }
    }

    func getGenerations() -> AnyPublisher<APIEvent<GenerationList>, Error> {
        return api.getGenerations()
    }

    func getGenerationsDetail(results: [GenerationResultItem]) -> AnyPublisher<APIEvent<[Generation]>, Error> {
        var cancelBag = Set<AnyCancellable>()
        return AnyPublisher<APIEvent<[Generation]>, Error>.create { [weak self] subscriber in
            guard let self else { return AnyCancellable { } }
            subscriber.send(.loading)
            results
                .map { self.api.getGenerationDetail(url: $0.url) }
                .publisher
                .flatMap { $0.data() }
                .collect()
                .sink { completion in
                    switch completion {
                    case .finished:
                        subscriber.send(completion: .finished)

                    case let .failure(error):
                        subscriber.send(.error(error))
                        subscriber.send(completion: .finished)
                    }

                } receiveValue: { data in
                    subscriber.send(.loaded(data))
                    subscriber.send(completion: .finished)
                }
                .store(in: &cancelBag)

            return AnyCancellable {
                cancelBag.forEach { $0.cancel() }
            }
        }
    }

    func getGenerationsDTO(generations: [Generation]) -> AnyPublisher<APIEvent<[GenerationDTO]>, Error> {
        var cancelBag = Set<AnyCancellable>()
        let dispatchGroup = DispatchGroup()
        return AnyPublisher<APIEvent<[GenerationDTO]>, Error>.create { [weak self] subscriber in
            guard let self else { return AnyCancellable { } }
            var generationsDTO = [GenerationDTO]()

            generations.forEach { generation in
                dispatchGroup.enter()
                generation.species
                    .prefix(3)
                    .map { self.api.getPokemonObject(name: $0.name) }
                    .publisher
                    .flatMap { $0.data() }
                    .collect()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            dispatchGroup.leave()

                        case let .failure(error):
                            subscriber.send(.error(error))
                            subscriber.send(completion: .finished)
                        }
                    } receiveValue: { data in
                        generationsDTO.append(GenerationDTO(generation: generation, pokemons: data))
                    }
                    .store(in: &cancelBag)
            }

            dispatchGroup.notify(queue: .main) {
                let sortedGeneration = generationsDTO.sorted { $0.generation.romanNumber < $1.generation.romanNumber }
                subscriber.send(.loaded(sortedGeneration))
                subscriber.send(completion: .finished)
            }

            return AnyCancellable {
                cancelBag.forEach { $0.cancel() }
            }
        }
    }

    func getPokemonDetail(id: Int) -> AnyPublisher<APIEvent<PokemonDetail>, Error> {
        return api.getPokemonDetail(id: id)
    }
}
