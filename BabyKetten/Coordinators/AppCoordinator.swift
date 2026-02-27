import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    let tabBarController = UITabBarController()

    init() {
        navigationController = UINavigationController()
    }

    func start() {
        tabBarController.tabBar.tintColor = .systemRed

        let searchNav = UINavigationController()
        searchNav.navigationBar.tintColor = .systemRed
        searchNav.tabBarItem = UITabBarItem(title: "search", image: UIImage(named: "mic"), tag: 1)
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        searchCoordinator.start()

        let calendarNav = UINavigationController()
        calendarNav.navigationBar.tintColor = .systemRed
        calendarNav.tabBarItem = UITabBarItem(title: "calendar", image: UIImage(named: "calendar"), tag: 2)
        let calendarCoordinator = CalendarCoordinator(navigationController: calendarNav)
        calendarCoordinator.start()

        let favesNav = UINavigationController()
        favesNav.navigationBar.tintColor = .systemRed
        favesNav.tabBarItem = UITabBarItem(title: "faves", image: UIImage(named: "inbox"), tag: 3)
        let favesCoordinator = FavoritesCoordinator(navigationController: favesNav)
        favesCoordinator.start()

        let kamikazeNav = UINavigationController()
        kamikazeNav.navigationBar.tintColor = .systemRed
        kamikazeNav.tabBarItem = UITabBarItem(title: "kamikaze!", image: UIImage(named: "question"), tag: 4)
        let kamikazeCoordinator = KamikazeCoordinator(navigationController: kamikazeNav)
        kamikazeCoordinator.start()

        tabBarController.setViewControllers(
            [searchNav, calendarNav, favesNav, kamikazeNav],
            animated: false
        )

        childCoordinators = [searchCoordinator, calendarCoordinator, favesCoordinator, kamikazeCoordinator]
    }
}
