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
    private var refreshTokenService: RefreshTokenServiceProtocol?
    
    // MARK: - Coordinator
    
    func start() {
        if refreshTokenService != nil {
            checkTokenExpiration()
        } else {
            startFlow()
        }
    }
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol,
         tokenStorage: TokenStorageProtocol,
         refreshTokenService: RefreshTokenServiceProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.tokenStorage = tokenStorage
        self.refreshTokenService = refreshTokenService
    }
    
    // MARK: - Private helpers
    
    private func checkTokenExpiration() {
        if let token = tokenStorage.token {
            refreshTokenService?.refresh(token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                case .failure(_):
                    self.tokenStorage.token = nil
                }
                self.refreshTokenService = nil
                self.startFlow()
            }
        } else {
            refreshTokenService = nil
            startFlow()
        }
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
