//
//  PokemonListView.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import SwiftUI

struct PokemonListView: View {

    // MARK: - Properties

    // MARK: Wrappers

    @ObservedObject private var viewModel: PokemonListViewModel

    // MARK: Private

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    // MARK: - Constructors and destructors

    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            setUpBackground()
            setUpGridList()
        }
        .navigationTitle("Pokedex")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.filterButtonTapped.send()
                } label: {
                    Image("icAllFilters")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            viewModel.didAppear.send()
        }
    }

    private func setUpGridList() -> some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.pokemons, id: \.id) { pokemon in
                        PokemonGridView(pokemon: pokemon) {
                            viewModel.pokemonSelected.send($0)
                        }
                        .onAppear {
                            viewModel.loadNextPage.send(pokemon)
                        }
                    }
                }
                .padding(.horizontal, 25)

                if viewModel.isPaginationLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .padding(.top, 16.0)
            .padding(.bottom)
        }
    }

    private func setUpBackground() -> some View {
        GeometryReader { geo in
            HStack {
                ForEach(0..<5) { _ in
                    VStack {
                        ForEach(0..<50) { _ in
                            Image("pokeball")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat.random(in: 1...100), height: CGFloat.random(in: 1...100))
                                .transformEffect(CGAffineTransform(rotationAngle: CGFloat.random(in: -10...10)))
                                .opacity(Double.random(in: 0.1...1.0))
                                .padding()
                        }
                    }
                    .frame(width: geo.size.width / 5)
                }
            }
            .frame(width: geo.size.width)
        }
        .ignoresSafeArea()
    }
}

