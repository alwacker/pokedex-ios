//
//  FilterItemDTO.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Foundation

struct FilterItemDTO {
    enum FilterType {
        case favourite
        case allTypes
        case allGen
    }

    let icon: String
    let title: String
    let type: FilterType
}
