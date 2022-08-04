//
//  AuthorizationCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol AuthorizationCoordinatorOutput {
    
    var finishFlow: ((AuthorizationToken) -> Void)? { get set }
}

protocol AuthorizationCoordinatorProtocol: AnyObject {
    
    func finishAuthorization(token: AuthorizationToken)
}

class AuthorizationCoordinator: Coordinator,
                                AuthorizationCoordinatorOutput,
                                AuthorizationCoordinatorProtocol {
    
    // MARK: - Properties
    
    private let screenFactory: AuthorizationScreenFactoryProtocol
    private let router: CoordinatorRouterProtocol
    
    // MARK: - AuthorizationCoordinatorOutput
    
    var finishFlow: ((AuthorizationToken) -> Void)?
    
    // MARK: - Coordinator
    
    func start() {
        Logger.log("Starting authorization flow")
        let viewController = screenFactory.createAuthorizationScreen()
        viewController.coordinator = self
        router.transition(to: viewController)
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
        finishFlow?(token)
    }
}
