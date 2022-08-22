//
//  SummaryModelTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class SummaryModelTests: XCTestCase {
    
    var model: SummaryModel!
    var service: TimeEntriesServiceMock!
    
    override func setUp() {
        service = TimeEntriesServiceMock()
    }
    
    override func tearDown() {
        model = nil
        service = nil
    }
    
    func testSaveTimeEntryCreateSuccess() {
        // Arrange
        service.createStub = true
        model = SummaryModel(service: service,
                             timeEntryID: nil,
                             userID: 5,
                             taskHref: "task",
                             projectHref: "project",
                             timeSpent: Date(),
                             taskTitle: "title",
                             projectTitle: "projectTitle",
                             comment: "comment"
        )
        var success: Bool!
        
        // Act
        model.saveTimeEntry() { result in
            success = result
        }
        
        // Assert
        XCTAssertTrue(success)
    }
    
    func testSaveTimeEntryCreateFailure() {
        // Arrange
        service.createStub = false
        model = SummaryModel(service: service,
                             timeEntryID: nil,
                             userID: 5,
                             taskHref: "task",
                             projectHref: "project",
                             timeSpent: Date(),
                             taskTitle: "title",
                             projectTitle: "projectTitle",
                             comment: "comment"
        )
        var success: Bool!
        
        // Act
        model.saveTimeEntry() { result in
            success = result
        }
        
        // Assert
        XCTAssertFalse(success)
    }
    
    func testSaveTimeEntryUpdateSuccess() {
        // Arrange
        service.updateStub = true
        model = SummaryModel(service: service,
                             timeEntryID: 10,
                             userID: 5,
                             taskHref: "task",
                             projectHref: "project",
                             timeSpent: Date(),
                             taskTitle: "title",
                             projectTitle: "projectTitle",
                             comment: "comment"
        )
        var success: Bool!
        
        // Act
        model.saveTimeEntry() { result in
            success = result
        }
        
        // Assert
        XCTAssertTrue(success)
    }
    
    func testSaveTimeEntryUpdateFailure() {
        // Arrange
        service.updateStub = false
        model = SummaryModel(service: service,
                             timeEntryID: 10,
                             userID: 5,
                             taskHref: "task",
                             projectHref: "project",
                             timeSpent: Date(),
                             taskTitle: "title",
                             projectTitle: "projectTitle",
                             comment: "comment"
        )
        var success: Bool!
        
        // Act
        model.saveTimeEntry() { result in
            success = result
        }
        
        // Assert
        XCTAssertFalse(success)
    }
}
