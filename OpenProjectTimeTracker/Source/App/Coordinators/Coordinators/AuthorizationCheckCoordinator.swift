//
//  AuthorizationCheck.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation

protocol AuthorizationCheckOutput {
    var finishFlow: (() -> Void)? { get set}
}

protocol AuthorizationCheckProtocol {
    
}

final class AuthorizationCheckCoordinator: Coordinator,
                                           AuthorizationCheckProtocol,
                                           AuthorizationCheckOutput {
    
    // MARK: - Properties
    
    private let service: RefreshTokenServiceProtocol
    private let tokenStorage: TokenStorageProtocol
    
    // MARK: - Lifecycle
    
    init(service: RefreshTokenServiceProtocol,
         tokenStorage: TokenStorageProtocol) {
        self.service = service
        self.tokenStorage = tokenStorage
    }
    
    // MARK: AuthorizationCheckOutput
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Coordinator
    
    func start() {
        Logger.log("Starting authorization check flow")
        if let token = tokenStorage.token {
            service.refresh(token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    Logger.log("Status: authorized")
                    self.tokenStorage.token = token
                case .failure(_):
                    Logger.log("Status: token refreshing failed")
                    self.tokenStorage.token = nil
                }
                self.finishFlow?()
            }
        } else {
            Logger.log("Status: anauthorized")
            finishFlow?()
        }
    }
}
