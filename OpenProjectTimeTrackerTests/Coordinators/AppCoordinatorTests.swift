//
//  AppCoordinatorTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class AppCoordinatorTests: XCTestCase {
    
    var coordinator: AppCoordinator!
    var factory: CoordinatorFactoryMock!
    var router: CoordinatorRouterMock!
    var tokenStorage: TokenStorageMock!
    var timerDataStorage: TimerDataStorageMock!
    
    override func setUp() {
        factory = CoordinatorFactoryMock()
        router = CoordinatorRouterMock()
        tokenStorage = TokenStorageMock()
        timerDataStorage = TimerDataStorageMock()
        coordinator = AppCoordinator(
            router: router,
            coordinatorFactory: factory,
            tokenStorage: tokenStorage,
            timerDataStorage: timerDataStorage
        )
    }
    
    override func tearDown() {
        coordinator = nil
        factory = nil
        router = nil
        tokenStorage = nil
        timerDataStorage = nil
    }
    
    func testStart() {
        // Act
        coordinator.start()
        
        // Assert
        XCTAssertTrue(factory.authorizationCheckCoordinator.startCalled)
    }
    
    func testStartAuthorization() {
        // Arrange
        timerDataStorage.userID = 2
        
        // Act
        coordinator.start()
        factory.authorizationCheckCoordinator.finishFlow?()
        factory.authorizationCoordinator.finishFlow?()
        
        // Assert
        XCTAssertTrue(factory.authorizationCheckCoordinator.startCalled)
        XCTAssertTrue(factory.authorizationCoordinator.startCalled)
    }
    
    func testStartTimer() {
        // Arrange
        timerDataStorage.userID = 2
        tokenStorage.token = AuthorizationToken(oauthToken: "oauth", refreshToken: "refresh")
        
        // Act
        coordinator.start()
        factory.authorizationCheckCoordinator.finishFlow?()
        factory.projectCoordinator.finishFlow?()
        
        // Assert
        XCTAssertTrue(factory.authorizationCheckCoordinator.startCalled)
        XCTAssertTrue(factory.projectCoordinator.startCalled)
    }
}
