//
//  SceneDelegate.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinatorProtocol?
    
    lazy var urlHandler = URLHandler()

    // MARK: - Lifecycle
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        let router = CoordinatorRouter(window: window!)
        let factory = CoordinatorFactory(router: router)
        
        appCoordinator = AppCoordinator(router: router, coordinatorFactory: factory)
        appCoordinator?.start()

        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        urlHandler.handle(context.url)
    }
}

