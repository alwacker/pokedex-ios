//
//  APIEndpoint.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation

enum APIEndpoint: String {
    case getPokemons = "pokemon"
    case getPokemon = "pokemon/%@"
    case getGenerations = "generation"
    case getPokemonDetail = "pokemon-species/%d"
}
