//
//  GenerationGridItem.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import SwiftUI
import Kingfisher

struct GenerationGridItem: View {

    // MARK: - Properties

    var generation: GenerationDTO

    var action: (GenerationDTO) -> Void

    // MARK: - Body

    var body: some View {
        Button {
            action(generation)
        } label: {
            ZStack {
                setUpBackground()
                setUpView()
            }
            .cornerRadius(15)
            .frame(width: (UIScreen.main.bounds.width / 2) - 35, height: 110)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black.opacity(0.3), lineWidth: 1)
            )
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0 , y: 2)
        .buttonStyle(.plain)
    }

    private func setUpView() -> some View {
        VStack(alignment: .center, spacing: 20) {
            Text(generation.generation.parsedName)
                .font(.system(.bold, 14.0))

            HStack(spacing: 0) {
                ForEach(generation.pokemons, id: \.id) {
                    if let url = $0.imageURL {
                        KFImage(url)
                            .cacheMemoryOnly()
                            .fade(duration: 0.25)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .padding(.horizontal, 16.0)
    }

    private func setUpBackground() -> some View {
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
    }
}
