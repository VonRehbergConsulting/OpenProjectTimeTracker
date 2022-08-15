//
//  UserService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation
import OAuthSwift

protocol UserServiceProtocol {
    
    func getUserID(_ completion: @escaping ((Result<Int, Error>) -> Void))
    
}

final class UserService: UserServiceProtocol {
    
    // MARK: - Response model
    
    private struct UserDataResponse: Codable {
        var id: Int
    }
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    private let requestFactory: UserDataRequestFactoryProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol,
         requestFactory: UserDataRequestFactory
    ) {
        self.service = service
        self.requestFactory = requestFactory
    }
    
    // MARK: - UserServiceProtocol
    
    func getUserID(_ completion: @escaping ((Result<Int, Error>) -> Void)) {
        let requestConfig = requestFactory.createUserDataRequestConfig()
        service.send(requestConfig: requestConfig, completion)
    }
}
