//
//  SceneDelegate.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let tabBarController: UITabBarController

    let search: UINavigationController
    let calendar: UINavigationController
    let faves: UINavigationController
    let kamikaze: UINavigationController

    override init() {
        search = UINavigationController(rootViewController: SearchViewController())
        search.navigationBar.tintColor = .systemRed
        search.tabBarItem = UITabBarItem(title: "search", image: UIImage(named: "mic"), tag: 1)

        calendar = UINavigationController(rootViewController: CalendarViewController())
        calendar.navigationBar.tintColor = .systemRed
        calendar.tabBarItem = UITabBarItem(title: "calendar", image: UIImage(named: "calendar"), tag: 2)

        faves = UINavigationController(rootViewController: FavoritesListTableViewController())
        faves.navigationBar.tintColor = .systemRed
        faves.tabBarItem = UITabBarItem(title: "faves", image: UIImage(named: "inbox"), tag: 3)

        kamikaze = UINavigationController(rootViewController: KamikazeViewController())
        kamikaze.navigationBar.tintColor = .systemRed
        kamikaze.tabBarItem = UITabBarItem(title: "kamikaze!", image: UIImage(named: "question"), tag:4)

        tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .systemRed
        tabBarController.setViewControllers(
            [search, calendar, faves, kamikaze],
            animated: false
        )
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
