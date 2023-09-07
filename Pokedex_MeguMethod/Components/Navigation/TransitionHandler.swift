//
//  TransitionHandler.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import UIKit

public protocol TransitionHandler {
    func push(controller: UIViewController, animated: Bool)
    func modal(controller: UIViewController, animated: Bool)
}

extension UIViewController: TransitionHandler {
    public func modal(controller: UIViewController, animated: Bool) {
        present(controller, animated: animated, completion: nil)
    }

    public func push(controller: UIViewController, animated: Bool) {
        navigationController?.pushViewController(controller, animated: animated)
    }
}
