//
//  PokemonDetailView.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {

    // MARK: - Properties

    // MARK: Wrappers

    @ObservedObject private var viewModel: PokemonDetailViewModel

    @State private var scrollOffset: CGPoint = .zero

    // MARK: - Constructors and destructors

    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            OffsetObservingScrollView(axes: .vertical, offset: $scrollOffset) {
                VStack(alignment: .leading, spacing: 0) {
                    setUpHeader()
                    setUpImage()

                    ZStack {
                        GeometryReader { geo in
                            Color.white
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(25.0, corners: [.topRight, .topLeft])
                                .ignoresSafeArea()
                                .padding(.bottom, -1000)
                        }
                        setUpSection()
                    }
                }
                .background(Color(uiColor: viewModel.pokemonDetail?.pokemon.types.first?.type.kind.color() ?? .white))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(scrollOffset.y <= 40 ? "" : (viewModel.pokemonDetail?.pokemon.name.capitalized ?? ""))
        .onAppear {
            viewModel.didAppear.send()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    viewModel.backButtonPressed.send()
                } label: {
                    Image("backArrow")
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeButtonPressed.send()
                } label: {
                    Image(viewModel.isFavourite ? "heardChecked" : "heardUnchecked")
                }
            }
        }
        .background(Color(uiColor: viewModel.pokemonDetail?.pokemon.types.first?.type.kind.color() ?? .white))
    }

    private func setUpHeader() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                Text(viewModel.pokemonDetail?.pokemon.name.capitalized ?? "")
                    .font(.system(.black, 36.0))
                    .foregroundColor(.white)
                Spacer()
                VStack {
                    Spacer()
                    Text(viewModel.pokemonDetail?.pokemon.nameId ?? "")
                        .font(.system(.black, 18.0))
                        .frame(height: 36)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .frame(height: 40.0)

            HStack {
                ForEach(viewModel.pokemonDetail?.pokemon.types ?? [], id: \.slot) {
                    Text($0.type.kind.rawValue.capitalized)
                        .foregroundColor(.white)
                        .font(.system(.bold, 12.0))
                        .frame(height: 25)
                        .padding(.horizontal, 20)
                        .background(.white.opacity(0.3))
                        .cornerRadius(38)
                }
                Spacer()
                Text(viewModel.pokemonDetail?.pokemonDetail.genName ?? "")
                    .font(.system(.bold, 14.0))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16.0)
        }
    }

    private func setUpImage() -> some View {
        HStack {
            Spacer()
            KFImage(viewModel.pokemonDetail?.pokemon.imageURL)
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .resizable()
                .frame(width: 230, height: 230)
            Spacer()
        }
        .offset(y: 40)
        .zIndex(1)
    }

    private func setUpSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.pokemonDetail?.pokemonDetail.description ?? "")
                .font(.system(.medium, 16.0))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 100) {
                VStack(alignment: .leading, spacing: 11.0) {
                    Text("Height")
                        .font(.system(.bold, 16.0))
                        .foregroundColor(.black.opacity(0.4))

                    Text(viewModel.pokemonDetail?.pokemon.heightText ?? "")
                        .font(.system(.medium, 14.0))
                }
                .padding(.leading)

                VStack(alignment: .leading, spacing: 11.0) {
                    Text("Weight")
                        .font(.system(.bold, 16.0))
                        .foregroundColor(.black.opacity(0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(viewModel.pokemonDetail?.pokemon.weightText ?? "")
                        .font(.system(.medium, 14.0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.trailing)

            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.13), radius: 11.5, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 24.0) {
                Text("Breeding")
                    .font(.system(.bold, 16.0))

                HStack(spacing: 60) {
                    VStack(alignment: .leading, spacing: 18.0) {
                        Text("Gender")
                            .font(.system(.bold, 16.0))
                            .foregroundColor(.black.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Egg Groups")
                            .font(.system(.bold, 16.0))
                            .foregroundColor(.black.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 100)


                    VStack(alignment: .leading, spacing: 18.0) {
                        HStack(spacing: 18.0) {
                            HStack {
                                Image("male")
                                Text(viewModel.pokemonDetail?.pokemonDetail.malePersentageText ?? "")
                                    .font(.system(.regular, 14.0))
                            }

                            HStack {
                                Image("female")
                                Text(viewModel.pokemonDetail?.pokemonDetail.femalePersentageText ?? "")
                                    .font(.system(.regular, 14.0))
                            }
                        }

                        Text(viewModel.pokemonDetail?.pokemonDetail.eggGroupDescription ?? "")
                            .font(.system(.regular, 16.0))
                    }

                }
            }

            VStack(alignment: .leading, spacing: 24.0) {
                Text("Training")
                    .font(.system(.bold, 16.0))
                HStack(spacing: 60) {
                    Text("Base EXP")
                        .font(.system(.bold, 16.0))
                        .foregroundColor(.black.opacity(0.4))
                        .frame(width: 100, alignment: .leading)

                    Text("\(viewModel.pokemonDetail?.pokemon.baseExperience ?? 0)")
                        .font(.system(.regular, 14.0))
                }
            }
        }
        .padding(.top, 50.0)
        .padding(.horizontal, 16.0)
    }
}
