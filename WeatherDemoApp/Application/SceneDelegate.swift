//
//  SceneDelegate.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 28/1/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let appDIContainer = AppDIContainer(networkService: ImplNetworkService(),
                                                localService: ImplSwiftDataService())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(navigation: navigationController, appDIContainer: appDIContainer)
        appCoordinator?.start()
    }
}
