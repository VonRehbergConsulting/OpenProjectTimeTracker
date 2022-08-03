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
    
    var service: AuthorizationServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: AuthorizationServiceProtocol) {
        self.service = service
    }
    
    // MARK: - AuthorizationScreenFactory
    
    func createAuthorizationScreen() -> AuthorizationViewController {
        let viewController = AuthorizationViewController()
        
        viewController.authorizationService = service
        service.viewController = viewController
        
        return viewController
    }
}
