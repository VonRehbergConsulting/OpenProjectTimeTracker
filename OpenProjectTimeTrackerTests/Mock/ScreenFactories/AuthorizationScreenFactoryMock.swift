//
//  AuthorizationScreenFactoryMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker
import UIKit

final class AuthorizationScreenFactoryMock: AuthorizationScreenFactoryProtocol {
    
    var authorizationScreen = AuthorizationViewController()
    func createAuthorizationScreen() -> AuthorizationViewController {
        return authorizationScreen
    }
}
