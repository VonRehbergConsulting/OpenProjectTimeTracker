//
//  ProjectsCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol ProjectsCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

protocol ProjectsCoordinatorProtocol: AnyObject {
    
}

class ProjectsCoordinator: Coordinator,
                           ProjectsCoordinatorProtocol,
                           ProjectsCoordinatorOutput{
    
    // MARK: - ProjectsCoordinatorOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Properties
    
    private let router: CoordinatorRouterProtocol
    
    // MARK: - ProjectsCoordinatorProtocol
    
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
