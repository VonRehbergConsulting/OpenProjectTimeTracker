//
//  CoordinatorFactoryMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker

final class CoordinatorFactoryMock: CoordinatorFactoryProtocol {
    
    lazy var authorizationCheckCoordinator = CoordinatorMock()
    func createAuthorizationCheckCoordinator() -> Coordinator {
        authorizationCheckCoordinator
    }
    
    lazy var authorizationCoordinator = CoordinatorMock()
    func createAuthorizationCoordinator() -> Coordinator {
        authorizationCoordinator
    }
    
    lazy var projectCoordinator = CoordinatorMock()
    func createProjectsCoordinator() -> Coordinator {
        projectCoordinator
    }
}
