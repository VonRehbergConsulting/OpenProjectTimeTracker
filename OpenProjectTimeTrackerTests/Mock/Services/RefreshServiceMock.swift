//
//  RefreshServiceMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 17.08.22.
//

@testable import OpenProjectTimeTracker

final class RefreshTokenServiceMock: RefreshTokenServiceProtocol {
    
    var refreshStub: (Result<AuthorizationToken, Error>)?
    func refresh(_ token: AuthorizationToken, completion: @escaping (Result<AuthorizationToken, Error>) -> Void) {
        guard let refreshStub = refreshStub else { return }
        completion(refreshStub)
    }
}
