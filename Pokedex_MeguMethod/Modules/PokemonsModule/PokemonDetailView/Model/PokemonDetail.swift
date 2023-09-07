//
//  PokemonDetail.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Foundation

struct PokemonDetail: Decodable {

    enum CodingKeys: String, CodingKey {
        case textEntries = "flavor_text_entries"
        case genderRate = "gender_rate"
        case genera
        case eggGroups = "egg_groups"
    }

    let textEntries: [TextEntry]
    let genderRate: Int
    let genera: [Genus]
    let eggGroups: [EggGroup]

    var femalePercentage: Double {
        return 100.0 / (Double(genderRate) * 8.0)
    }

    var malePersentageText: String {
        return "\(100.0 - femalePercentage)%"
    }

    var femalePersentageText: String {
        return "\(femalePercentage)%"
    }

    var genName: String {
        let filteredGenera = genera.filter { $0.language.name == "en" }
        return filteredGenera.first?.genus.capitalized ?? ""
    }

    var description: String {
        let filteredTextEntries = textEntries.filter { $0.language.name == "en" && $0.version.name == "ruby" }
        let trimmedText = filteredTextEntries.first?.text.trimmingCharacters(in: .newlines)
        return trimmedText ?? ""
    }

    var eggGroupDescription: String {
        return eggGroups.first?.name.capitalized ?? ""
    }
}

struct EggGroup: Decodable {
    let name: String
}

struct Genus: Decodable {
    let genus: String
    let language: Language
}

struct TextEntry: Decodable {
    enum CodingKeys: String, CodingKey {
        case text = "flavor_text"
        case language
        case version
    }

    let text: String
    let language: Language
    let version: Version
}

struct Language: Decodable {
    let name: String
}

struct Version: Decodable {
    let name: String
}
