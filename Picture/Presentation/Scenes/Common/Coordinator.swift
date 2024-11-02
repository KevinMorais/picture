//
//  Coordinator.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [any Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}
