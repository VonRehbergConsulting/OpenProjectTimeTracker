//
//  AuthorizationCoordinatorTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class AuthorizationCoordinatorTests: XCTestCase {
    
    var coordinator: AuthorizationCoordinator!
    var factory: AuthorizationScreenFactoryMock!
    var router: CoordinatorRouterMock!
    var timerDataStorage: TimerDataStorageMock!
    
    override func setUp() {
        factory = AuthorizationScreenFactoryMock()
        router = CoordinatorRouterMock()
        timerDataStorage = TimerDataStorageMock()
        coordinator = AuthorizationCoordinator(
            router: router,
            screenFactory: factory,
            timerDataStorage: timerDataStorage
        )
    }
    
    override func tearDown() {
        coordinator = nil
        factory = nil
        router = nil
        timerDataStorage = nil
    }
    
    func testStart() {
        // Act
        coordinator.start()
        
        // Assert
        XCTAssertTrue(router.transitionCalled)
    }
    
    func testAuthorizationScreenFinishFlow() {
        // Arrange
        var finishFlowCalled = false
        coordinator.finishFlow = {
            finishFlowCalled = true
        }
        
        // Act
        coordinator.start()
        factory.authorizationScreen.finishFlow?(20)
        
        // Assert
        XCTAssertTrue(finishFlowCalled)
        XCTAssertEqual(timerDataStorage.userID, 20)
    }
}

