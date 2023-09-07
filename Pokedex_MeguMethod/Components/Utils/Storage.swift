//
//  Storage.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 07.09.2023.
//

import Foundation

enum Keys: String {
    case favouriteItems
}

class Storage {

    static let instanse = Storage()

    private let userDefaults = UserDefaults.standard

    var favouritePokemons: [String] {
        get {
            if let array = userDefaults.object(forKey: Keys.favouriteItems.rawValue) as? [String] {
                return array
            }

            return []
        }
        set {
            userDefaults.set(newValue, forKey: Keys.favouriteItems.rawValue)
        }
    }
}
