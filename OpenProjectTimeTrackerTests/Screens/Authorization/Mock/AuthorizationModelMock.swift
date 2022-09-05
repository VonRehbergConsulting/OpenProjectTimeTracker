//
//  AuthorizationModelMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker

final class AuthorizationModelMock: AuthorizationModelProtocol {
    
    var authorizeStub: Bool!
    func authorize(_ completion: @escaping (Bool) -> Void) {
        completion(authorizeStub)
    }
    
    var getUserIDStub: Int?
    func getUserID(_ completion: @escaping (Int?) -> Void) {
        completion(getUserIDStub)
    }
}
