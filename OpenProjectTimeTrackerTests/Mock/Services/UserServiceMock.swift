//
//  UserServiceMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 17.08.22.
//

@testable import OpenProjectTimeTracker

final class UserServiceMock: UserServiceProtocol {
    
    var getUserIDStub: Result<Int, Error>?
    func getUserID(_ completion: @escaping ((Result<Int, Error>) -> Void)) {
        guard let getUserIDStub = getUserIDStub else { return }
        completion(getUserIDStub)
    }
}
