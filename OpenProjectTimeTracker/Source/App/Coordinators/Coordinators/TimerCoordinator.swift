//
//  TimerCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol TimerCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

protocol TimerCoordinatorProtocol: AnyObject {
    
}

class TimerCoordinator: Coordinator,
                        TimerCoordinatorProtocol,
                        TimerCoordinatorOutput {
    
    // MARK: - Properties
    
    private let screenFactory: TimerScreenFactoryProtocol
    private let router: CoordinatorRouterProtocol
    private let service: UserServiceProtocol
    
    // MARK: - TimerCoordinatorOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Lifecycle
    
    init(screenFactory: TimerScreenFactoryProtocol,
         router: CoordinatorRouterProtocol,
         service: UserServiceProtocol) {
        self.screenFactory = screenFactory
        self.router = router
        self.service = service
    }
    
    // MARK: - TimerCoordinatorProtocol
    
    func start() {
        Logger.log("Starting timer flow")
        Logger.log("Requesting user id")
        service.getUserID() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let id):
                Logger.log(event: .success, "User id recieved")
                self.showScreen(id: id)
            case.failure(let error):
                Logger.log(event: .error, "Unable to get user id: \(error)")
                self.finishFlow?()
            }
        }
    }
    
    // MARK: - Private helpers
    
    private func showScreen(id: Int) {
        let viewController = screenFactory.createTimerScreen(userID: id)
        router.transition(to: viewController)
    }
}
