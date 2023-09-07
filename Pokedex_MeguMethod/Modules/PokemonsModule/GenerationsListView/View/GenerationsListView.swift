//
//  GenerationsListView.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import SwiftUI

struct GenerationsListView: View {

    // MARK: - Properties

    // MARK: Wrappers

    @ObservedObject private var viewModel: GenerationsListViewModel

    // MARK: Private

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    // MARK: - Constructors and destructors

    init(viewModel: GenerationsListViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.generations, id: \.generation.name) { generation in
                    GenerationGridItem(generation: generation) {
                        viewModel.generationSelected.send($0)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 16.0)
        }
        .navigationTitle("Generation")
        .onAppear {
            viewModel.didAppear.send()
        }
    }
}
