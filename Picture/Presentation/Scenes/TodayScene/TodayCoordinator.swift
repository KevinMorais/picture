//
//  TodayCoordinator.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

protocol TodayCoordinatorDelegate: AnyObject {
    func userDidTapOnCard(_ selectedPhoto: Photo)
    func userDidTapDismiss()
}

final class TodayCoordinator: NSObject, Coordinator {

    let navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []

    private let factory: any TodaySceneFactoryProtocol

    init(
        navigationController: UINavigationController,
        factory: some TodaySceneFactoryProtocol = TodaySceneFactory()
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        self.navigationController.setNavigationBarHidden(true, animated: false)
        let todayViewController = self.factory.createTodayViewController(coordinator: self)
        self.navigationController.delegate = self
        self.navigationController.setViewControllers([todayViewController], animated: true)
    }

}

// MARK: - TodayCoordinatorDelegate

extension TodayCoordinator: TodayCoordinatorDelegate {

    func userDidTapOnCard(_ selectedPhoto: Photo) {
        let viewController = self.factory.createTodayDetailsViewController(
            dataSource: .init(selectedPhoto: selectedPhoto),
            coordinator: self
        )
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func userDidTapDismiss() {
        self.navigationController.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension TodayCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard operation == .push else {
            return nil
        }
        return PresentTodayDetailsAnimatedTransitioning()
    }
}
