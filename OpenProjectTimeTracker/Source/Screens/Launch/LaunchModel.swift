//
//  LaunchScreenModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation

protocol LaunchModelProtocol {
    
    func checkAuthorization(_ completion: @escaping (LaunchModel.State) -> Void)
    
    func getUserID(_ completion: @escaping (Int?) -> Void)
}

final class LaunchModel: LaunchModelProtocol {
    
    // MARK: - State
    
    enum State {
        case authorized
        case unauthorized
        case unableToAccess
    }
    
    // MARK: - Properties
    
    private let refreshService: RefreshTokenServiceProtocol
    private let userService: UserServiceProtocol
    private let tokenStorage: TokenStorageProtocol
    
    weak var presenter: LaunchPresenterProtocol?
    
    // MARK: - Lifecycle
    
    init(refreshService: RefreshTokenServiceProtocol,
         userService: UserServiceProtocol,
         tokenStorage: TokenStorageProtocol) {
        self.refreshService = refreshService
        self.userService = userService
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - LaunchModelProtocol
    
    func checkAuthorization(_ completion: @escaping (State) -> Void) {
        if let token = tokenStorage.token {
            refreshService.refresh(token) { result in
                switch result {
                case .success(_):
                    Logger.log("Status: authorized")
                    completion(.authorized)
                case .failure(let error):
                    Logger.log("Status: token refreshing failed: \(error)")
                    if let networkError = error as? NetworkError,
                       networkError == .unanthorized {
                        completion(.unauthorized)
                    } else {
                        completion(.unableToAccess)
                    }
                }
            }
        } else {
            Logger.log("Status: anauthorized")
            completion(.unauthorized)
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
