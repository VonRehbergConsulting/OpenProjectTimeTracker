//
//  TimerPresenterTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimerPresenterTests: XCTestCase {
    
    var presenter: TimerPresenter!
    var model: TimerModelMock!
    
    override func setUp() {
        model = TimerModelMock()
        presenter = TimerPresenter()
        presenter.model = model
    }
    
    override func tearDown() {
        presenter = nil
        model = nil
    }
    
    // MARK: - timeSpent
    
    func testTimeSpent_noData() {
        // Arrange
        model.startTime = nil
        
        // Act
        let timeSpent = presenter.timeSpent
        
        // Assert
        XCTAssertNil(timeSpent)
    }
    
    func testTimeSpentActive() {
        func testTimeSpent_noData() {
            // Arrange
            model.startTime = Date().addingTimeInterval(-7384)
            model.stopTime = nil
            
            // Act
            let timeSpent = presenter.timeSpent
            
            // Assert
            XCTAssertEqual(timeSpent?.hour, 2)
            XCTAssertEqual(timeSpent?.minute, 3)
            XCTAssertEqual(timeSpent?.second, 4)
        }
    }
    
    func testTimeSpentInactive() {
        func testTimeSpent_noData() {
            // Arrange
            model.startTime = Date().addingTimeInterval(-11047)
            model.stopTime = Date().addingTimeInterval(-11045)
            
            // Act
            let timeSpent = presenter.timeSpent
            
            // Assert
            XCTAssertEqual(timeSpent?.hour, 3)
            XCTAssertEqual(timeSpent?.minute, 4)
            XCTAssertEqual(timeSpent?.second, 5)
        }
    }
    
    // MARK: - setTimeEntry
    
    func testSetTimeEntry() {
        // Arrange
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let timeEntry = TimeEntryListModel(
            id: 1,
            projectTitle: "project",
            workPackageTitle: "task",
            workPackageID: 10,
            timeSpent: components,
            comment: "comment"
        )
        
        // Act
        presenter.setTimeEntry(timeEntry)
        
        // Assert
        XCTAssertEqual(model.timeEntryID, 1)
        XCTAssertNotNil(model.stopTime)
        XCTAssertNotNil(model.startTime)
    }
    
    // MARK: - startTimer
    
    func testStartTimer() {
        // Arrange
        model.startTime = nil
        
        // Act
        presenter.startTimer()
        
        // Assert
        XCTAssertNotNil(model.startTime)
    }
    
    func testResumeTimer() {
        // Arrange
        model.startTime = Date().addingTimeInterval(-100)
        model.stopTime = Date().addingTimeInterval(-50)
        
        // Act
        presenter.startTimer()
        
        // Assert
        XCTAssertNil(model.stopTime)
    }
    
    // MARK: - stopTimer
    
    func testStopTimer() {
        // Arrange
        model.stopTime = nil
        
        // Act
        presenter.stopTimer()
        
        // Assert
        XCTAssertNotNil(model.stopTime)
    }
    
    // MARK: - resetTimer
    
    func testResetTimer() {
        // Arrange
        model.startTime = Date()
        model.stopTime = Date()
        model.timeEntryID = 12
        model.comment = "comment"
        
        // Act
        presenter.resetTimer()
        
        // Assert
        XCTAssertNil(model.startTime)
        XCTAssertNil(model.stopTime)
        XCTAssertNil(model.timeEntryID)
        XCTAssertNil(model.comment)
    }
}
