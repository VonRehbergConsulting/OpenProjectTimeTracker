//
//  CoordinatorRouter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol CoordinatorRouterProtocol: AnyObject {
    
    func transition(to viewController: UIViewController)
    
    func push(_ viewController: UIViewController, animated: Bool)
    
    func pop(animated: Bool)
}

class CoordinatorRouter: CoordinatorRouterProtocol {
    
    // MARK: - Propertie
    
    private let window: UIWindow
    private var navigationController: UINavigationController = .init()
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - CoordinatorRouterProtocol
    
    func transition(to viewController: UIViewController) {
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = false
        
        window.rootViewController = navigationController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.6
        UIView.transition(with: window, duration: duration, options: options, animations: {})
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
