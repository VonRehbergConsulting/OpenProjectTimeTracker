//
//  CoordinatorFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    
    func createAuthorizationCheckCoordinator() -> Coordinator
    
    func createAuthorizationCoordinator() -> Coordinator
    
    func createProjectsCoordinator() -> Coordinator
    
}

class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    // MARK: - Properties
    
    private let router: CoordinatorRouterProtocol
    
    private let tokenStorage: TokenStorageProtocol
    private let timerDataStorage: TimerDataStorageProtocol
    
    private let authorizationService: AuthorizationServiceProtocol
    private let refreshService: RefreshTokenServiceProtocol
    private let requestService: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         tokenStorage: TokenStorageProtocol,
         timerDataStorage: TimerDataStorageProtocol,
         authorizationService: AuthorizationServiceProtocol,
         refreshService: RefreshTokenServiceProtocol,
         requestService: RequestServiceProtocol
    ) {
        self.router = router
        self.tokenStorage = tokenStorage
        self.timerDataStorage = timerDataStorage
        self.authorizationService = authorizationService
        self.refreshService = refreshService
        self.requestService = requestService
    }
    
    // MARK: - CoordinatorFactoryProtocol
    
    func createAuthorizationCheckCoordinator() -> Coordinator {
        let userService = UserService(service: requestService, requestFactory: UserDataRequestFactory())
        let screenFactory = LaunchScreenFactory(
            refreshService: refreshService,
            userService: userService,
            tokenStorage: tokenStorage,
            timerDataStorage: timerDataStorage
        )
        let coordinator = AuthorizationCheckCoordinator(
            factory: screenFactory,
            router: router,
            tokenStorage: tokenStorage,
            timerDataStorage: timerDataStorage
        )
        return coordinator
    }
    
    func createAuthorizationCoordinator() -> Coordinator {
        let userService = UserService(service: requestService, requestFactory: UserDataRequestFactory())
        let screenFactory = AuthorizationScreenFactory(authorizationService: authorizationService,
                                                       userService: userService
        )
        let coordinator = AuthorizationCoordinator(router: router,
                                                   screenFactory: screenFactory,
                                                   timerDataStorage: timerDataStorage
        )
        return coordinator
    }
    
    func createProjectsCoordinator() -> Coordinator {
        let screenFactory = TimerScreenFactory(service: requestService, timerDataStorage: timerDataStorage)
        let coordinator = TimerCoordinator(screenFactory: screenFactory, router: router, timerDataStorage: timerDataStorage)
        return coordinator
    }
    
}
