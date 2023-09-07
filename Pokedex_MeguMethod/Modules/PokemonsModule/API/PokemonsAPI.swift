//
//  PokemonsAPI.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import Combine

class PokemonsAPI: BaseApi {

    func getFirstPage() -> AnyPublisher<APIEvent<PokemonPage>, Error> {
        return request(endPoint: .getPokemons)
    }

    func getPokemonObject(url: String) -> AnyPublisher<APIEvent<Pokemon>, Error> {
        return request(endPoint: url)
    }

    func getPokemonObject(name: String) -> AnyPublisher<APIEvent<Pokemon>, Error> {
        let endpoint = getEndpointUrl(endPoint: String(format: APIEndpoint.getPokemon.rawValue, name))
        return request(endPoint: endpoint)
    }

    func getNextPage(url: String) -> AnyPublisher<APIEvent<PokemonPage>, Error> {
        return request(endPoint: url)
    }

    func getGenerations() -> AnyPublisher<APIEvent<GenerationList>, Error> {
        return request(endPoint: .getGenerations)
    }

    func getGenerationDetail(url: String) -> AnyPublisher<APIEvent<Generation>, Error> {
        return request(endPoint: url)
    }

    func getPokemonDetail(id: Int) -> AnyPublisher<APIEvent<PokemonDetail>, Error> {
        let endpoint = getEndpointUrl(endPoint: String(format: APIEndpoint.getPokemonDetail.rawValue, id))
        return request(endPoint: endpoint)
    }
}
