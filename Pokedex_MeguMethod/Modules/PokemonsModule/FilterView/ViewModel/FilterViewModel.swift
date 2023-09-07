//
//  FilterViewModel.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Combine

class FilterViewModel: ObservableObject {
    
    // MARK: - Properties

    // MARK: Inputs

    let filterItemTapped = PassthroughSubject<FilterItemDTO.FilterType, Never>()

    let closeButtonTapped = PassthroughSubject<Void, Never>()

    // MARK: Outputs

    @Published var filters: [FilterItemDTO] = [
        FilterItemDTO(icon: "heardChecked", title: "Favourite Pokemon", type: .favourite),
        FilterItemDTO(icon: "purplePokeball", title: "All Type", type: .allTypes),
        FilterItemDTO(icon: "purplePokeball", title: "All Gen", type: .allGen)
    ]

    // MARK: Private

    private var cancelBag = Set<AnyCancellable>()

    // MARK: - Constructors and destructors

    init(context: PokemonsRouter.FilterContext) {
        filterItemTapped.sink {
            context.filterTypeSelected.send($0)
        }
        .store(in: &cancelBag)

        closeButtonTapped.sink {
            context.closeFilterPressed.send()
        }
        .store(in: &cancelBag)
    }
}
