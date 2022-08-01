//
//  ScreenFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import UIKit

protocol ScreenFactoryProtocol {
    
    func createAuthorizationScreen(apiKey: APIKey) -> AuthorizationViewController
    
}

class ScreenFactory: ScreenFactoryProtocol {
    
    func createAuthorizationScreen(apiKey: APIKey) -> AuthorizationViewController {
        let viewController = AuthorizationViewController()
        let service = AuthorizationService(apiKey: apiKey)
        
        viewController.authorizationService = service
        service.viewController = viewController
        
        return viewController
    }
}
