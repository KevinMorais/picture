//
//  SceneDelegate.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var mainCoordinator: (any MainCoordinatorProtocol)?

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        self.mainCoordinator = MainCoordinator()
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = self.mainCoordinator?.rootViewController
        self.mainCoordinator?.start()
        self.window?.makeKeyAndVisible()
    }
}
