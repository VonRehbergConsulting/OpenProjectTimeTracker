//
//  SceneDelegate.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit
import OAuthSwift

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
        
        let navigationController = UINavigationController()
        let router = CoordinatorRouter(window: window!, navigationController: navigationController)
        let tokenStorage = TokenStorage()
        let timerDataStorage = TimerDataStorage()
        let oauth2swift = OAuth2Swift(viewController: navigationController)
        let service = OpenProjectService(tokenStorage: tokenStorage, oauth2swift: oauth2swift)
        let factory = CoordinatorFactory(
            router: router,
            tokenStorage: tokenStorage,
            timerDataStorage: timerDataStorage,
            authorizationService: service,
            refreshService: service,
            requestService: service
        )
        
        appCoordinator = AppCoordinator(router: router,
                                        coordinatorFactory: factory,
                                        tokenStorage: tokenStorage,
                                        timerDataStorage: timerDataStorage
        )
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        urlHandler.handle(context.url)
    }
}

