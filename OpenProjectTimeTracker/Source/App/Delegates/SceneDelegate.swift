//
//  SceneDelegate.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?
    
    lazy var urlHandler = URLHandler()

    // MARK: - Lifecycle
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        let router = CoordinatorRouter(window: window!)
        let factory = CoordinatorFactory(router: router)
        let tokenStorage = TokenStorage()
        let refreshService = AuthorizationService(apiKey: .openProject)
        
        appCoordinator = AppCoordinator(router: router,
                                        coordinatorFactory: factory,
                                        tokenStorage: tokenStorage,
                                        refreshTokenService: refreshService
        )
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        urlHandler.handle(context.url)
    }
}

