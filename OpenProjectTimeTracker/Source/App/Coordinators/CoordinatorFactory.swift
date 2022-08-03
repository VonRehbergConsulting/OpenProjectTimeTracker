//
//  CoordinatorFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    
    func createAuthorizationCoordinator() -> AuthorizationCoordinator
    
    func createProjectsCoordinator() -> ProjectsCoordinator
    
}

class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    // MARK: - Properties
    
    private var apiKey: APIKey {
        guard let path = Bundle.main.path(forResource: "OpenProjectKey", ofType: "plist")
        else {
            Logger.log(event: .error, "Can't find API key file")
            return .zero
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url),
              let result = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else {
            Logger.log(event: .error, "Can't read API key file")
            return .zero
        }
        return result
    }
    
    private let router: CoordinatorRouterProtocol
    
    // MARK: - Lifecycle
    
    init(router: CoordinatorRouterProtocol) {
        self.router = router
    }
    
    // MARK: - CoordinatorFactoryProtocol
    
    func createAuthorizationCoordinator() -> AuthorizationCoordinator {
        let service = AuthorizationService(apiKey: apiKey)
        let screenFactory = AuthorizationScreenFactory(service: service)
        let coordinator = AuthorizationCoordinator(router: router, screenFactory: screenFactory)
        return coordinator
    }
    
    func createProjectsCoordinator() -> ProjectsCoordinator {
        let coordinator = ProjectsCoordinator(router: router)
        return coordinator
    }
    
}
