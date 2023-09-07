//
//  FilterItemView.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import SwiftUI

struct FilterItemView: View {

    // MARK: - Properties

    var dto: FilterItemDTO

    var action: (FilterItemDTO.FilterType) -> Void

    // MARK: - Body

    var body: some View {
        Button {
            action(dto.type)
        } label: {
            HStack(alignment: .center, spacing: 14.0) {
                Text(dto.title)
                    .font(.system(.bold, 14.0))

                Image(dto.icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 17.0, height: 17.0)
                    .foregroundColor(Color(red: 0.42, green: 0.47, blue: 0.86))
            }
            .padding(.horizontal, 15)
            .padding(.vertical)
            .background(.white)
            .cornerRadius(33)
        }
        .buttonStyle(.plain)
    }
}
