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
    private let timerDataStorage: TimerDataStorageProtocol
    
    private var isJustStarted = true
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol,
         tokenStorage: TokenStorageProtocol,
         timerDataStorage: TimerDataStorageProtocol
    ) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.tokenStorage = tokenStorage
        self.timerDataStorage = timerDataStorage
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
        if tokenStorage.token == nil || timerDataStorage.userID == nil {
            startAuthorizationFlow()
        } else {
            startTimerFlow()
        }
    }
    
    private func startAuthorizationFlow() {
        let coordinator = coordinatorFactory.createAuthorizationCoordinator()
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
    
    private func startTimerFlow() {
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
