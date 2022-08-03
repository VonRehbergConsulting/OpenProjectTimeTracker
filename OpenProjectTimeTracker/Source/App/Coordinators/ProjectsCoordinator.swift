//
//  ProjectsCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol ProjectsCoordinatorProtocol: Coordinator {
    
}

class ProjectsCoordinator: ProjectsCoordinatorProtocol {
    
    // MARK: - Properties
    
    private var childCoordinators: [Coordinator] = []
    private let router: CoordinatorRouterProtocol
    
    // MARK: - ProjectsCoordinatorProtocol
    
    var finishFlow: (() -> Void)?
    
    func start() {
        Logger.log("Starting projects flow")
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemGreen
        router.setRootViewController(viewController)
    }
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol) {
        self.router = router
    }
    
    
}
