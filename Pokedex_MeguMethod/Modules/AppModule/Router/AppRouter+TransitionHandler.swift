//
//  AppRouter+TransitionHandler.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import UIKit

extension AppRouter: TransitionHandler {
    public func push(controller: UIViewController, animated: Bool) {
        let pushBlock = {
            self.show(
                controller: controller,
                options: AppRouterOptions(
                    navigation: .Push(options: .Plain, animated: animated)
                )
            )
        }

        if Thread.isMainThread {
            pushBlock()
        } else {
            DispatchQueue.main.sync {
                pushBlock()
            }
        }
    }

    public func modal(controller: UIViewController, animated: Bool) {
        let modalBlock = {
            self.show(
                controller: controller,
                options: AppRouterOptions(
                    navigation: .Dialog(options: .Plain, animated: animated)
                )
            )
        }
        if Thread.isMainThread {
            modalBlock()
        } else {
            DispatchQueue.main.sync {
                modalBlock()
            }
        }
    }
}
