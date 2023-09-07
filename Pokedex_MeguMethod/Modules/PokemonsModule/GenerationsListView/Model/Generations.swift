//
//  Generations.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Foundation

struct GenerationList: Decodable {
    let results: [GenerationResultItem]
}

struct GenerationResultItem: Decodable {
    let url: String
}

struct Generation: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case species = "pokemon_species"
    }
    let name: String
    let species: [Species]

    var parsedName: String {
        let separatedName = name.components(separatedBy: "-")
        if separatedName.count == 2 {
            return separatedName[0].capitalized + " " + separatedName[1].uppercased()
        }
        return name
    }

    var romanNumber: Int {
        let separatedName = name.components(separatedBy: "-")
        return separatedName.last?.uppercased().romanToInt() ?? 0
    }
}

struct GenerationDTO {
    let generation: Generation
    let pokemons: [Pokemon]
}
