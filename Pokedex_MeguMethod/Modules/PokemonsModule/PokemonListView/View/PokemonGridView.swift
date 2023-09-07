//
//  PokemonGridView.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import SwiftUI
import Kingfisher

struct PokemonGridView: View {

    // MARK: - Properties

    var pokemon: Pokemon

    var action: (Pokemon) -> Void

    // MARK: - Body

    var body: some View {
        Button {
            action(pokemon)
        } label: {
            ZStack(alignment: .leading) {
                Color(uiColor: pokemon.types.first?.type.kind.color() ?? .gray)
                setUpBackground()
                setUpItems()
            }
            .frame(width: (UIScreen.main.bounds.width / 2) - 35, height: 110)
            .cornerRadius(15)

        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0 , y: 2)
        .buttonStyle(.plain)
    }

    private func setUpItems() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(pokemon.nameId)
                    .font(.system(.bold, 14.0))
                    .foregroundColor(.white.opacity(0.3))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(pokemon.name.capitalized)
                    .foregroundColor(.white)
                    .font(.system(.bold, 14.0))

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(pokemon.types, id: \.slot) {
                        Text($0.type.kind.rawValue.capitalized)
                            .foregroundColor(.white)
                            .font(.system(.bold, 8.0))
                            .frame(height: 16)
                            .padding(.horizontal, 6)
                            .background(.white.opacity(0.3))
                            .cornerRadius(38)
                    }

                    if pokemon.types.count == 1 {
                        Spacer()
                            .frame(height: 16)
                    }
                }
            }
        }
        .padding(.horizontal, 16.0)
    }

    private func setUpBackground() -> some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("pokeball")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 90)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.white.opacity(0.3))
                        .transformEffect(CGAffineTransform(rotationAngle: -0.09))
                        .opacity(0.4)
                }
            }

            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    if let url = pokemon.imageURL {
                        KFImage(url)
                            .cacheMemoryOnly()
                            .fade(duration: 0.25)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
    }
}

