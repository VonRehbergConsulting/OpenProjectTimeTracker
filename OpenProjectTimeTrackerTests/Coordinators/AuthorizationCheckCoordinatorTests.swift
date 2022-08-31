//
//  AuthorizationCheckCoordinatorTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class AuthorizationCheckCoordinatorTests: XCTestCase {
    
    var coordinator: AuthorizationCheckCoordinator!
    var factory: LaunchScreenFactoryMock!
    var router: CoordinatorRouterMock!
    var tokenStorage: TokenStorageMock!
    var timerDataStorage: TimerDataStorageMock!
    
    override func setUp() {
        factory = LaunchScreenFactoryMock()
        router = CoordinatorRouterMock()
        tokenStorage = TokenStorageMock()
        timerDataStorage = TimerDataStorageMock()
        coordinator = AuthorizationCheckCoordinator(
            factory: factory,
            router: router,
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
        XCTAssertTrue(router.transitionCalled)
    }
    
    func testLaunchScreenFinishFlowSuccess() {
        // Arrange
        var finishFlowCalled = false
        coordinator.finishFlow = {
            finishFlowCalled = true
        }
        
        // Act
        coordinator.start()
        factory.launchScreen.finishFlow?(20)
        
        // Assert
        XCTAssertTrue(finishFlowCalled)
        XCTAssertEqual(timerDataStorage.userID, 20)
    }
    
    func testLaunchScreenFinishFlowFailure() {
        // Arrange
        tokenStorage.token = AuthorizationToken(oauthToken: "asd", refreshToken: "asd")
        var finishFlowCalled = false
        coordinator.finishFlow = {
            finishFlowCalled = true
        }
        
        // Act
        coordinator.start()
        factory.launchScreen.finishFlow?(nil)
        
        // Assert
        XCTAssertTrue(finishFlowCalled)
        XCTAssertNil(timerDataStorage.userID)
        XCTAssertNil(tokenStorage.token)
    }
}
