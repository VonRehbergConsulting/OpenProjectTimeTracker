//
//  TimerModelTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimerModelTests: XCTestCase {
    
    var model: TimerModel!
    var timerDataStorage: TimerDataStorageMock!
    
    override func setUp() {
        timerDataStorage = TimerDataStorageMock()
    }
    
    override func tearDown() {
        model = nil
        timerDataStorage = nil
    }
    
    // MARK: - isActive
    
    func testIsActive_noData() {
        // Arrange
        model = TimerModel(userID: 10, storage: timerDataStorage)
        
        // Assert
        XCTAssertFalse(model.isActive)
    }
    
    func testIsActive_true() {
        // Arrange
        model = TimerModel(userID: 10, storage: timerDataStorage)
        timerDataStorage.startTime = Date()
        timerDataStorage.stopTime = nil
        
        // Assert
        XCTAssertTrue(model.isActive)
    }
    
    func testIsActive_false() {
        // Arrange
        model = TimerModel(userID: 10, storage: timerDataStorage)
        timerDataStorage.startTime = Date()
        timerDataStorage.stopTime = Date()
        
        // Assert
        XCTAssertFalse(model.isActive)
    }
    
    // MARK: - initialCheck
    
    func testInitialCheck_tooLong() {
        // Arrange
        var clearCalled = false
        timerDataStorage.clearStub = {
            clearCalled = true
        }
        timerDataStorage.task = Task(selfHref: "self", subject: "subj", projectHref: "proj")
        timerDataStorage.startTime = Date().addingTimeInterval(-36001)
        
        // Act
        model = TimerModel(userID: 10, storage: timerDataStorage)
        
        // Assert
        XCTAssertTrue(clearCalled)
    }
    
    func testInitialCheck_correctData() {
        // Arrange
        var clearCalled = false
        timerDataStorage.clearStub = {
            clearCalled = true
        }
        timerDataStorage.task = Task(selfHref: "self", subject: "subj", projectHref: "proj")
        timerDataStorage.startTime = Date().addingTimeInterval(-1)
        
        // Act
        model = TimerModel(userID: 10, storage: timerDataStorage)
        
        // Assert
        XCTAssertFalse(clearCalled)
    }
    
    func testInitialCheck_noData() {
        // Arrange
        var clearCalled = false
        timerDataStorage.clearStub = {
            clearCalled = true
        }
        timerDataStorage.task = nil
        timerDataStorage.startTime = nil
        
        // Act
        model = TimerModel(userID: 10, storage: timerDataStorage)
        
        // Assert
        XCTAssertTrue(clearCalled)
    }
    
    // MARK: - properties
    
    func testProperties() {
        // Arrange
        let timeEntryID = 1
        let task = Task(selfHref: "Self", subject: "Subj", projectHref: "Proj")
        let startTime = Date()
        let stopTime = Date().addingTimeInterval(10)
        let comment = "comment"
        model = TimerModel(userID: 10, storage: timerDataStorage)
        
        // Act
        model.timeEntryID = timeEntryID
        model.task = task
        model.startTime = startTime
        model.stopTime = stopTime
        model.comment = comment
        
        // Assert
        XCTAssertEqual(timerDataStorage.timeEntryID, timeEntryID)
        XCTAssertEqual(timerDataStorage.task?.selfHref, "Self")
        XCTAssertEqual(timerDataStorage.startTime, startTime)
        XCTAssertEqual(timerDataStorage.stopTime, stopTime)
        XCTAssertEqual(timerDataStorage.comment, comment)
        XCTAssertEqual(model.timeEntryID, timeEntryID)
        XCTAssertEqual(model.comment, comment)
    }
}
