//
//  NavigationViewController.swift
//  Pokedex_MeguMethod
//
//  Created by Oleksandr Vaker on 05.09.2023.
//

import UIKit

class NavigationViewController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpNavigationBar(
        tintColor: UIColor? = .black,
        backgroundColor: UIColor? = .white,
        separatorColor: UIColor? = .clear,
        titleFont: UIFont? = UIFont.system(.black, 22.0),
        titleColor: UIColor? = .black,
        largeTitleFont: UIFont? = UIFont.system(.black, 36.0),
        largeTitleColor: UIColor? = .black,
        backIndicatorImage: UIImage? = nil,
        backIndicatorMaskImage: UIImage? = nil,
        translucent: Bool = false
    ) {
        let appearance = UINavigationBarAppearance()

        // Background color
        appearance.backgroundColor = backgroundColor

        // Separator color
        appearance.shadowColor = separatorColor

        // Tint color
        navigationBar.tintColor = tintColor

        // Title
        var titleTextAttributes: [NSAttributedString.Key: Any] = [:]
        titleTextAttributes[.font] = titleFont
        titleTextAttributes[.foregroundColor] = titleColor
        appearance.titleTextAttributes = titleTextAttributes

        // Large title
        var largeTitleTextAttributes: [NSAttributedString.Key: Any] = [:]
        largeTitleTextAttributes[.font] = largeTitleFont
        largeTitleTextAttributes[.foregroundColor] = largeTitleColor
        appearance.largeTitleTextAttributes = largeTitleTextAttributes

        // Back indicator
        appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)

        // Translucency
        appearance.backgroundEffect = translucent ? UIBlurEffect(style: .systemChromeMaterial) : nil

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

