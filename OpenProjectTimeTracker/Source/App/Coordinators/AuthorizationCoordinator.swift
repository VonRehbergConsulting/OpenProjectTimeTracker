//
//  AuthorizationCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol AuthorizationCoordinatorProtocol: AnyObject {
    
    func finishAuthorization(token: AuthorizationToken)
}

class AuthorizationCoordinator: Coordinator, AuthorizationCoordinatorProtocol {
    
    // MARK: - Properties
    
    private let screenFactory: AuthorizationScreenFactoryProtocol
    private var childCoordinators: [Coordinator] = []
    private let router: CoordinatorRouterProtocol
    
    // MARK: - Coordinator
    
    var finishFlow: (() -> Void)?
    
    func start() {
        Logger.log("Starting authorization flow")
        let viewController = screenFactory.createAuthorizationScreen()
        viewController.coordinator = self
        router.setRootViewController(viewController)
    }
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         screenFactory: AuthorizationScreenFactoryProtocol) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    // MARK: - AuthorizationCoordinatorProtocol
    
    func finishAuthorization(token: AuthorizationToken) {
        Logger.log("OAuth token: " + token.oauthToken)
        Logger.log("Refresh token: " + token.refreshToken)
        finishFlow?()
    }
}
