//
//  Navigator.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import UIKit

class Navigator {
    static var rootViewController: UIViewController? {
        if let window = UIApplication.shared.delegate?.window {
            return window?.rootViewController
        }
        return nil
    }

    static func getRootNavigationViewController(rootController: UIViewController) -> UINavigationController {
        let rootViewController = Navigator.rootViewController
        if let rootNavigationController = rootViewController as? NavigationViewController {
            return rootNavigationController
        } else {
            let navigationController = NavigationViewController(rootViewController: rootController)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.isOpaque = true
            return navigationController
        }
    }

    static func showModalViewController(
        _ vc: UIViewController,
        inNavigationController: Bool,
        animated: Bool) {
        let root = Navigator.rootViewController
        vc.modalPresentationStyle = .automatic
        root?.present(vc, animated: animated)
    }
}
