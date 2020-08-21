//
//  KamikazeCoordinator.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/19/19.
//

import UIKit

final class KamikazeCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "kamikaze!", image: UIImage(systemName: "questionmark.circle"), tag: 2)
    }
    
    func start() {
        let vc = KamikazeViewController()
        navigationController.pushViewController(vc, animated: false)
    }
}
