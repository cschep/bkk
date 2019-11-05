//
//  FavoritesCoordinator.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/19/19.
//

import SwiftUI
import UIKit

final class FavoritesCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "favorites", image: UIImage(systemName: "star.fill"), tag: 1)
    }
    
    func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemPink
        navigationController.pushViewController(vc, animated: false)
    }
}
