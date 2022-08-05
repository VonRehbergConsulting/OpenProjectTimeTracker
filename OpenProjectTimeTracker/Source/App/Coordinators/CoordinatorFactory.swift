//
//  CoordinatorFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    
    func createAuthorizationCheckCoordinator() -> AuthorizationCheckCoordinator
    
    func createAuthorizationCoordinator() -> AuthorizationCoordinator
    
    func createProjectsCoordinator() -> TimerCoordinator
    
}

class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    // MARK: - Properties
    
    private let router: CoordinatorRouterProtocol
    
    private let tokenStorage: TokenStorageProtocol
    
    private let authorizationService: AuthorizationServiceProtocol
    private let refreshService: RefreshTokenServiceProtocol
    private let requestService: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         tokenStorage: TokenStorageProtocol,
         authorizationService: AuthorizationServiceProtocol,
         refreshService: RefreshTokenServiceProtocol,
         requestService: RequestServiceProtocol
    ) {
        self.router = router
        self.tokenStorage = tokenStorage
        self.authorizationService = authorizationService
        self.refreshService = refreshService
        self.requestService = requestService
    }
    
    // MARK: - CoordinatorFactoryProtocol
    
    func createAuthorizationCheckCoordinator() -> AuthorizationCheckCoordinator {
        AuthorizationCheckCoordinator(service: refreshService, tokenStorage: tokenStorage)
    }
    
    func createAuthorizationCoordinator() -> AuthorizationCoordinator {
        let screenFactory = AuthorizationScreenFactory(service: authorizationService)
        let coordinator = AuthorizationCoordinator(router: router,
                                                   screenFactory: screenFactory)
        return coordinator
    }
    
    func createProjectsCoordinator() -> TimerCoordinator {
        let screenFactory = TimerScreenFactory(service: requestService)
        let userService = UserService(service: requestService)
        let coordinator = TimerCoordinator(screenFactory: screenFactory, router: router, service: userService)
        return coordinator
    }
    
}
