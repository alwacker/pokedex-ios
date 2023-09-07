//
//  FilterView.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import SwiftUI

struct FilterView: View {

    // MARK: - Properties

    // MARK: Wrappers

    @ObservedObject private var viewModel: FilterViewModel

    // MARK: - Constructors and destructors

    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .trailing) {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(alignment: .trailing, spacing: 18) {
                Spacer()
                VStack(alignment: .trailing, spacing: 14) {
                    ForEach(viewModel.filters, id: \.title) {
                        FilterItemView(dto: $0) { type in
                            viewModel.filterItemTapped.send(type)
                        }
                    }
                }
                setUpCancelButton()
            }
            .padding(.horizontal, 26)
        }
    }

    private func setUpCancelButton() -> some View {
        Button {
            viewModel.closeButtonTapped.send()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 50)
                    .foregroundColor(Color(red: 0.42, green: 0.47, blue: 0.86))

                Image("cross")
            }
        }
        .buttonStyle(.plain)
    }
}
