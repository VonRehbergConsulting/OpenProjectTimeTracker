//
//  AppCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private var coordinatorFactory: CoordinatorFactoryProtocol
    private var childCoordinators: [Coordinator] = []
    private let router: CoordinatorRouterProtocol
    private let tokenStorage: TokenStorageProtocol
    
    private var isJustStarted = true
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol,
         tokenStorage: TokenStorageProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Coordinator
    
    func start() {
        if isJustStarted {
            isJustStarted = false
            startAuthorizationCheckFlow()
        } else {
            startFlow()
        }
    }
    
    // MARK: - Private helpers
    
    private func startAuthorizationCheckFlow() {
        let coordinator = coordinatorFactory.createAuthorizationCheckCoordinator()
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
    
    private func startFlow() {
        if tokenStorage.token == nil {
            startAuthorizationFlow()
        } else {
            startProjectsFlow()
        }
    }
    
    private func startAuthorizationFlow() {
        let coordinator = coordinatorFactory.createAuthorizationCoordinator()
        childCoordinators.append(coordinator)
        coordinator.finishFlow = { [weak self] token in
            guard let self = self else {
                Logger.log(event: .warning, "Can't find app coordinator")
                return
            }
            self.childCoordinators.removeAll { $0 === coordinator }
            self.tokenStorage.token = token
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
