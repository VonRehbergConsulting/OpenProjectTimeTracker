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
//        window?.overrideUserInterfaceStyle = .dark
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        let router = CoordinatorRouter(window: window!)
        let tokenStorage = TokenStorage()
        let timerDataStorage = TimerDataStorage()
        let service = OpenProjectService(apiKey: .openProject, tokenStorage: tokenStorage)
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
                                        tokenStorage: tokenStorage
        )
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        urlHandler.handle(context.url)
    }
}

