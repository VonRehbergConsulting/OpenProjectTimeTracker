//
//  AuthorizationServiceMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

import UIKit
@testable import OpenProjectTimeTracker

class AuthorizationServiceMock: AuthorizationServiceProtocol {
    
    var viewController: UIViewController?
    
    var authorizeStub: (Result<AuthorizationToken, Error>)?
    func authorize(_ completion: @escaping ((Result<AuthorizationToken, Error>) -> Void)) {
        if let authorizeStub = authorizeStub {
            completion(authorizeStub)
        }
    }
}
