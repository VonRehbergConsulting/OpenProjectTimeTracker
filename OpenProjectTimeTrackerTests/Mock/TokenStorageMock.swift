//
//  TokenStorageMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 17.08.22.
//

@testable import OpenProjectTimeTracker

final class TokenStorageMock: TokenStorageProtocol {
    var token: AuthorizationToken?
}
