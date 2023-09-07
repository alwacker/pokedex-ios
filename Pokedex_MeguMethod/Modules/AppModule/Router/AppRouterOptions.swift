//
//  AppRouterOptions.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import Foundation
import UIKit

public class AppRouterOptions: NSObject {
    public static var Default: AppRouterOptions {
        return AppRouterOptions()
    }

    public static var ModalWithNavigation: AppRouterOptions {
        return AppRouterOptions(navigation: .Modal(
                options: .Navigation,
                animated: true,
                presentationStyle: .automatic,
                prefferedSize: nil)
        )
    }

    public static var ModalWithoutNavigation: AppRouterOptions {
        return AppRouterOptions(navigation:
            .Modal(
                options: .Plain,
                animated: true,
                presentationStyle: .automatic,
                prefferedSize: nil)
        )
    }

    public enum NavigationType {
        public enum PushOptions {
            case ResetHistory
            case ReplaceLastItem
            case Plain
        }

        public enum ModalOptions {
            case Navigation
            case Plain
        }

        case Modal(options: ModalOptions, animated: Bool, presentationStyle: UIModalPresentationStyle, prefferedSize: CGSize?)
        case Dialog(options: ModalOptions, animated: Bool)
        case Push(options: PushOptions, animated: Bool)
    }

    public let navigation: NavigationType

    public init(navigation: NavigationType = .Push(options: .Plain, animated: true)) {
        self.navigation = navigation
        super.init()
    }
}
