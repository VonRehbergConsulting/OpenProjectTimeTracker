//
//  UserService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation
import OAuthSwift

protocol UserServiceProtocol {
    
    func getUserID(_ completion: @escaping ((String) -> Void))
    
}

final class UserService: UserServiceProtocol {
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - UserServiceProtocol
    
    func getUserID(_ completion: @escaping ((String) -> Void)) {
        // TODO: implement it
    }
}
