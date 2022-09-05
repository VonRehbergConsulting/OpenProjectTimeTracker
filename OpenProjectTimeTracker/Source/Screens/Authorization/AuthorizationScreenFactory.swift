//
//  AuthorizationScreenFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import UIKit

protocol AuthorizationScreenFactoryProtocol {
    
    func createAuthorizationScreen() -> AuthorizationViewController
    
}

class AuthorizationScreenFactory: AuthorizationScreenFactoryProtocol {
    
    // MARK: - Properties
    
    private let authorizationService: AuthorizationServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: - Lifecycle
    
    init(authorizationService: AuthorizationServiceProtocol,
         userService: UserServiceProtocol
    ) {
        self.authorizationService = authorizationService
        self.userService = userService
    }
    
    // MARK: - AuthorizationScreenFactory
    
    func createAuthorizationScreen() -> AuthorizationViewController {
        let viewController = AuthorizationViewController()
        let presenter = AuthorizationPresenter()
        let model = AuthorizationModel(authorizationService: authorizationService, userService: userService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
}
