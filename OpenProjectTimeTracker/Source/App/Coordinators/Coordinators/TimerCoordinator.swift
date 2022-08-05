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
                        TimerCoordinatorOutput{
    
    // MARK: - TimerCoordinatorOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Properties
    
    private let router: CoordinatorRouterProtocol
    
    // MARK: - TimerCoordinatorProtocol
    
    func start() {
        Logger.log("Starting projects flow")
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemGreen
        router.transition(to: viewController)
    }
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol) {
        self.router = router
    }
    
    
}
