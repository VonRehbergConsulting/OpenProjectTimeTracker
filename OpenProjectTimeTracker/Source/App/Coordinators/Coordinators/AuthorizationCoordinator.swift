//
//  AuthorizationCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol AuthorizationCoordinatorProtocol: AnyObject {
    
}

class AuthorizationCoordinator: Coordinator,
                                AuthorizationCoordinatorProtocol {
    
    // MARK: - Properties
    
    private let screenFactory: AuthorizationScreenFactoryProtocol
    private let router: CoordinatorRouterProtocol
    private let timerDataStorage: TimerDataStorageProtocol
    
    // MARK: - AuthorizationCoordinatorOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol,
         screenFactory: AuthorizationScreenFactoryProtocol,
         timerDataStorage: TimerDataStorageProtocol
    ) {
        self.screenFactory = screenFactory
        self.router = router
        self.timerDataStorage = timerDataStorage
    }
    
    // MARK: - Coordinator
    
    func start() {
        Logger.log("Starting authorization flow")
        let viewController = screenFactory.createAuthorizationScreen()
        viewController.finishFlow = { [weak self] userID in
            guard let self = self else { return }
            self.timerDataStorage.userID = userID
            self.finishFlow?()
        }
        router.transition(to: viewController)
    }
}
