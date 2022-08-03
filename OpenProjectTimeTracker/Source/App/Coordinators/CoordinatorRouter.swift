//
//  CoordinatorRouter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol CoordinatorRouterProtocol {
    
    func setRootViewController(_ viewController: UIViewController)
    
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
    
    func setRootViewController(_ viewController: UIViewController) {
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        
        window.rootViewController = navigationController
        let options: UIView.AnimationOptions = .transitionFlipFromTop
        let duration: TimeInterval = 0.6
        UIView.transition(with: window, duration: duration, options: options, animations: {})
    }
}
