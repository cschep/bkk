import UIKit

class CalendarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = CalendarViewController()
        vc.onEventSelected = { [weak self] event in
            self?.showEventDetail(event: event)
        }
        navigationController.pushViewController(vc, animated: false)
    }

    private func showEventDetail(event: CalendarEvent) {
        let vc = CalendarDetailViewController(event: event)
        navigationController.pushViewController(vc, animated: true)
    }
}
