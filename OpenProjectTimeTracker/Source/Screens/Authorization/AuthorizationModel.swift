//
//  AuthorizationModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 17.08.22.
//

import Foundation

protocol AuthorizationModelProtocol {
    
    func authorize(_ completion: @escaping (Bool) -> Void)
    func getUserID(_ completion: @escaping (Int?) -> Void)
}

final class AuthorizationModel: AuthorizationModelProtocol {
    
    // MARK: - Properties
    
    private let authorizationService: AuthorizationServiceProtocol
    private let userService: UserServiceProtocol
    
    weak var presenter: AuthorizationPresenterProtocol?
    
    // MARK: - Lifecycle
    
    init(authorizationService: AuthorizationServiceProtocol,
         userService: UserServiceProtocol
    ) {
        self.authorizationService = authorizationService
        self.userService = userService
    }
    
    // MARK: - AuthorizationModelProtocol
    
    func authorize(_ completion: @escaping (Bool) -> Void) {
        authorizationService.authorize { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func getUserID(_ completion: @escaping (Int?) -> Void) {
        Logger.log("Requesting user ID")
        userService.getUserID() { result in
            switch result {
            case .failure(let error):
                Logger.log(event: .failure, "Cant't get user ID: \(error)")
                completion(nil)
            case .success(let userID):
                Logger.log(event: .success, "Recieved user ID")
                completion(userID)
            }
        }
    }
}
