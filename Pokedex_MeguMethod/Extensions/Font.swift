//
//  Font.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import SwiftUI
import UIKit

enum FontWeightType: String {
    case bold
    case semibold
    case regular
    case medium
    case black
}

extension Font {
    static func system(_ weight: FontWeightType, _ size: Double) -> Font {
        .custom("SFProDisplay-\(weight.rawValue.capitalized)", size: size)
    }
}

extension UIFont {
    static func system(_ weight: FontWeightType, _ size: Double) -> UIFont {
        .init(name: "SFProDisplay-\(weight.rawValue.capitalized)", size: size) ?? UIFont()
    }
}
