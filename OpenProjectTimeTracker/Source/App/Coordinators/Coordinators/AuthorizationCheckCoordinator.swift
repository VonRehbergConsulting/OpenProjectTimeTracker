//
//  AuthorizationCheck.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation

protocol AuthorizationCheckCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

protocol AuthorizationCheckCoordinatorProtocol {
    
}

final class AuthorizationCheckCoordinator: Coordinator,
                                           AuthorizationCheckCoordinatorProtocol,
                                           AuthorizationCheckCoordinatorOutput {
    
    // MARK: - Properties
    
    private let factory: LaunchScreenFactoryProtocol
    private let router: CoordinatorRouterProtocol
    private let tokenStorage: TokenStorageProtocol
    private let timerDataStorage: TimerDataStorageProtocol
    
    // MARK: - Lifecycle
    
    init(factory: LaunchScreenFactoryProtocol,
         router: CoordinatorRouterProtocol,
         tokenStorage: TokenStorageProtocol,
         timerDataStorage: TimerDataStorageProtocol
    ) {
        self.factory = factory
        self.router = router
        self.tokenStorage = tokenStorage
        self.timerDataStorage = timerDataStorage
    }
    
    // MARK: AuthorizationCheckOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Coordinator
    
    func start() {
        Logger.log("Starting authorization check flow")
        let viewController = factory.createLaunchScreen()
        viewController.finishFlow = { [weak self] userID in
            guard let self = self else { return }
            if let userID = userID {
                self.timerDataStorage.userID = userID
            } else {
                self.clearData()
            }
            self.finishFlow?()
        }
        router.transition(to: viewController)
    }
    
    // MARK: - Private helpers
    
    private func clearData() {
        tokenStorage.token = nil
        timerDataStorage.clear()
    }
}
