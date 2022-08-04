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
    
    func createProjectsCoordinator() -> ProjectsCoordinator
    
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
    
    func createProjectsCoordinator() -> ProjectsCoordinator {
        let coordinator = ProjectsCoordinator(router: router)
        return coordinator
    }
    
}
