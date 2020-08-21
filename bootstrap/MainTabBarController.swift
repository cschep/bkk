//
//  MainTabBarController.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/19/19.
//

import UIKit

final class MainTabBarController: UITabBarController {
    let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
    let favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController())
    let kamikazeCoordinator = KamikazeCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        searchCoordinator.start()
        favoritesCoordinator.start()
        kamikazeCoordinator.start()
        
        viewControllers = [
            searchCoordinator.navigationController,
            favoritesCoordinator.navigationController,
            kamikazeCoordinator.navigationController
        ]
    }
}
