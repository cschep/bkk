//
//  SceneDelegate.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let coordinator = AppCoordinator()
        coordinator.start()
        appCoordinator = coordinator

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = coordinator.tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}
