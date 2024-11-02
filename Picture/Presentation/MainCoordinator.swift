//
//  MainCoordinator.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

protocol MainCoordinatorProtocol {
    var rootViewController: UITabBarController { get }
    func start()
}

final class MainCoordinator: MainCoordinatorProtocol {

    enum Tab: CaseIterable {
        case today

        var title: String {
            switch self {
            case .today:
                "tabbarItem.today"
            }
        }

        var imageName: String {
            switch self {
            case .today:
                "tabbar-today"
            }
        }
    }

    private var childCoordinators: [any Coordinator] = []

    let rootViewController: UITabBarController

    init(rootViewController: UITabBarController = .init()) {
        self.rootViewController = rootViewController
    }

    func start() {
        self.childCoordinators = self.createChildCoordinators()
        self.rootViewController.setViewControllers(
            self.childCoordinators.map { $0.navigationController },
            animated: false
        )
        self.childCoordinators.forEach { $0.start() }
    }

    private func createChildCoordinators() -> [Coordinator] {
        return Tab.allCases.map {
            return self.createCoordinator(for: $0)
        }
    }

    private func createCoordinator(for tab: Tab) -> Coordinator {
        switch tab {
        case .today:
            let navigationController = self.createNavigationController(for: tab)
            return TodayCoordinator(navigationController: navigationController)
        }
    }

    private func createNavigationController(for tab: Tab) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .init(
            title: tab.title,
            image: .init(named: tab.imageName),
            tag: tab.hashValue
        )
        return navigationController
    }
}
