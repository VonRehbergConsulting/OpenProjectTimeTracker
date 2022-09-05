//
//  TimerCoordinatorTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimerCoordinatorTests: XCTestCase {
    
    var coordinator: TimerCoordinator!
    var factory: TimerScreenFactoryMock!
    var router: CoordinatorRouterMock!
    var timerDataStorage: TimerDataStorageMock!
    
    override func setUp() {
        factory = TimerScreenFactoryMock()
        router = CoordinatorRouterMock()
        timerDataStorage = TimerDataStorageMock()
        coordinator = TimerCoordinator(
            screenFactory: factory,
            router: router,
            timerDataStorage: timerDataStorage
        )
    }
    
    override func tearDown() {
        coordinator = nil
        factory = nil
        router = nil
        timerDataStorage = nil
    }
    
    // MARK: - start
    
    func testStartSuccess() {
        // Arrange
        timerDataStorage.userID = 10
        
        // Act
        coordinator.start()
        
        // Assert
        XCTAssertTrue(router.transitionCalled)
    }
    
    func testStartFailure() {
        // Act
        coordinator.start()
        
        // Assert
        XCTAssertFalse(router.transitionCalled)
    }
    
    // MARK: - routeToSummary
    
    func testRouteToSummarySuccess() {
        // Arrange
        timerDataStorage.userID = 10
        var completionCalled = false
        
        // Act
        coordinator.routeToSummary(timeEntryID: nil, taskHref: "", projectHref: "", timeSpent: DateComponents(), taskTitle: nil, projectTitle: nil, comment: nil) {
            completionCalled = true
        }
        factory.summaryScreen.finishFlow?()
        
        // Assert
        XCTAssertTrue(router.pushCalled)
        XCTAssertTrue(router.popCalled)
        XCTAssertTrue(completionCalled)
    }
    
    func testRouteToSummaryFailed() {
        // Arrange
        var completionCalled = false
        
        // Act
        coordinator.routeToSummary(timeEntryID: nil, taskHref: "", projectHref: "", timeSpent: DateComponents(), taskTitle: nil, projectTitle: nil, comment: nil) {
            completionCalled = true
        }
        factory.summaryScreen.finishFlow?()
        
        // Assert
        XCTAssertFalse(completionCalled)
        XCTAssertFalse(router.pushCalled)
        XCTAssertFalse(router.popCalled)
    }
    
    // MARK: - routeToTaskList
    
    func testRouteToTaskListSuccess() {
        // Arrange
        timerDataStorage.userID = 10
        var completionCalled = false
        
        // Act
        coordinator.routeToTaskList() { _, _ in
            completionCalled = true
        }
        factory.taskListScreen.finishFlow?(Task(selfHref: "", subject: "", projectHref: ""), nil)
        
        // Assert
        XCTAssertTrue(router.pushCalled)
        XCTAssertTrue(router.popCalled)
        XCTAssertTrue(completionCalled)
    }
    
    func testRouteToTaskListFailed() {
        // Arrange
        var completionCalled = false
        
        // Act
        coordinator.routeToTaskList() {_, _ in
            completionCalled = true
        }
        factory.taskListScreen.finishFlow?(Task(selfHref: "", subject: "", projectHref: ""), nil)
        
        // Assert
        XCTAssertFalse(router.pushCalled)
        XCTAssertFalse(router.popCalled)
        XCTAssertFalse(completionCalled)
    }
}
