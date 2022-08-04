//
//  CoordinatorFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    
    func createAuthorizationCoordinator() -> AuthorizationCoordinator
    
    func createProjectsCoordinator() -> ProjectsCoordinator
    
}

class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    // MARK: - Properties
    
    private let router: CoordinatorRouterProtocol
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol) {
        self.router = router
    }
    
    // MARK: - CoordinatorFactoryProtocol
    
    func createAuthorizationCoordinator() -> AuthorizationCoordinator {
        let service = AuthorizationService(apiKey: APIKey.openProject)
        let screenFactory = AuthorizationScreenFactory(service: service)
        let coordinator = AuthorizationCoordinator(router: router,
                                                   screenFactory: screenFactory)
        return coordinator
    }
    
    func createProjectsCoordinator() -> ProjectsCoordinator {
        let coordinator = ProjectsCoordinator(router: router)
        return coordinator
    }
    
}
