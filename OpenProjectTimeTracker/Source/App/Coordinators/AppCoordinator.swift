//
//  AppCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    
}

class AppCoordinator: AppCoordinatorProtocol {
    
    // MARK: - Properties
    
    private var coordinatorFactory: CoordinatorFactoryProtocol
    private var childCoordinators: [Coordinator] = []
    private let router: CoordinatorRouterProtocol
    private var isAuthorized: Bool = false
    
    // MARK: - Coordinator
    
    var finishFlow: (() -> Void)?
    
    func start() {
        isAuthorized ?
        startProjectsFlow() :
        startAuthorizationFlow()
    }
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    // MARK: - Private helpers
    
    private func startAuthorizationFlow() {
        let coordinator = coordinatorFactory.createAuthorizationCoordinator()
        childCoordinators.append(coordinator)
        coordinator.finishFlow = { [weak self] in
            guard let self = self else {
                Logger.log(event: .warning, "Can't find app coordinator")
                return
            }
            self.childCoordinators.removeAll { $0 === coordinator }
            self.isAuthorized = true
            self.start()
        }
        
        coordinator.start()
        
    }
    
    private func startProjectsFlow() {
        let coordinator = coordinatorFactory.createProjectsCoordinator()
        childCoordinators.append(coordinator)
        coordinator.finishFlow = { [weak self] in
            guard let self = self else {
                Logger.log(event: .warning, "Can't find app coordinator")
                return
            }
            self.childCoordinators.removeAll { $0 === coordinator }
            self.start()
        }
        
        coordinator.start()
        
    }
    
}
