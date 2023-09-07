//
//  String+RomanToInt.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 06.09.2023.
//

import Foundation

private let romanNumbers: [Character: Int] = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]

extension String {
    func romanToInt() -> Int {
        var prev = 0, out = 0
        for i in self {
            let val = romanNumbers[i] ?? 0
            out += val <= prev ? prev : -prev
            prev = val
        }
        out += prev
        return out
    }
}
