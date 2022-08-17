//
//  LaunchScreenFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import UIKit

protocol LaunchScreenFactoryProtocol {
    
    func createLaunchScreen() -> LaunchViewController
}

final class LaunchScreenFactory: LaunchScreenFactoryProtocol {
    
    // MARK: - Properties
    
    private let refreshService: RefreshTokenServiceProtocol
    private let userService: UserServiceProtocol
    private let tokenStorage: TokenStorageProtocol
    private let timerDataStorage: TimerDataStorageProtocol
    
    // MARK: - Lifecycle
    
    init(refreshService: RefreshTokenServiceProtocol,
         userService: UserServiceProtocol,
         tokenStorage: TokenStorageProtocol,
         timerDataStorage: TimerDataStorageProtocol) {
        self.refreshService = refreshService
        self.userService = userService
        self.tokenStorage = tokenStorage
        self.timerDataStorage = timerDataStorage
    }
    
    // MARK: - LaunchScreenFactoryProtocol
    
    func createLaunchScreen() -> LaunchViewController {
        let viewController = LaunchViewController()
        let presenter = LaunchPresenter()
        
        let model = LaunchModel(refreshService: refreshService, userService: userService, tokenStorage: tokenStorage)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
    
}
