//
//  TimerDataStorageTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimerDataStorageTests: XCTestCase {
    
    var userDefaults: UserDefaultsMock!
    var storage: TimerDataStorage!
    
    override func setUp() {
        userDefaults = UserDefaultsMock()
        storage = TimerDataStorage(userDefaultsProtocol: userDefaults)
    }
    
    override func tearDown() {
        storage = nil
        userDefaults = nil
    }
    
    func testStorage() {
        // Arrange
        let task = Task(selfHref: "qwe", subject: "asd", projectHref: "zxc")
        let startTime = Date()
        let stopTime = Date().addingTimeInterval(4000)
        storage.userID = 4
        storage.timeEntryID = 5
        storage.task = task
        storage.startTime = startTime
        storage.stopTime = stopTime
        storage.comment = "comment"
        
        // Assert
        XCTAssertEqual(storage.userID, 4)
        XCTAssertEqual(storage.timeEntryID, 5)
        XCTAssertEqual(storage.task, task)
        XCTAssertEqual(storage.startTime, startTime)
        XCTAssertEqual(storage.stopTime, stopTime)
        XCTAssertEqual(storage.comment, "comment")
    }
    
    func testClear() {
        // Arrange
        let task = Task(selfHref: "qwe", subject: "asd", projectHref: "zxc")
        let startTime = Date()
        let stopTime = Date().addingTimeInterval(4000)
        storage.userID = 4
        storage.timeEntryID = 5
        storage.task = task
        storage.startTime = startTime
        storage.stopTime = stopTime
        storage.comment = "comment"
        
        // Act
        storage.clear()
        
        // Assert
        XCTAssertNil(storage.userID)
        XCTAssertNil(storage.timeEntryID)
        XCTAssertNil(storage.task)
        XCTAssertNil(storage.startTime)
        XCTAssertNil(storage.stopTime)
        XCTAssertNil(storage.comment)
    }
}
