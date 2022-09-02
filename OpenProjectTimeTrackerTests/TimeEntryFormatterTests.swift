//
//  TimeEntryFormatterTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 02.09.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimeEntryFormatterTests: XCTestCase {
    
    func testFormatDate() {
        // Arrange
        var components = DateComponents()
        components.day = 5
        components.month = 2
        components.year = 2020
        let date = Calendar.current.date(from: components)!
        
        // Act
        let dateString = TimeEntryFormatter.formatDate(date)
        
        // Assert
        XCTAssertEqual(dateString, "2020-02-05")
    }
    
    func testFormatDurationDate() {
        // Arrange
        var components = DateComponents()
        components.second = 12
        components.minute = 34
        components.hour = 16
        let date = Calendar.current.date(from: components)!
        
        // Act
        let durationString = TimeEntryFormatter.formatDuration(date)
        
        // Assert
        XCTAssertEqual(durationString, "PT16H34M12S")
    }
    
    func testFormatDurationComponents() {
        // Arrange
        var components = DateComponents()
        components.second = 12
        components.minute = 34
        components.hour = 16
        
        // Act
        let durationString = TimeEntryFormatter.formatDuration(components)
        
        // Assert
        XCTAssertEqual(durationString, "PT16H34M12S")
    }
    
    func testDecode() {
        // Arrange
        let hours = "PT16H34M12S"
        
        // Act
        let components = TimeEntryFormatter.decode(hours: hours)
        
        // Assert
        XCTAssertEqual(components?.hour, 16)
        XCTAssertEqual(components?.minute, 34)
        XCTAssertEqual(components?.second, 12)
    }
    
}
