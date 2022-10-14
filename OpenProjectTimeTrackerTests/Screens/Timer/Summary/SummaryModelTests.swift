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
                             timeSpent: DateComponents(),
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
                             timeSpent: DateComponents(),
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
                             timeSpent: DateComponents(),
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
                             timeSpent: DateComponents(),
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
    
    func testLoadSuggestionsSuccess() {
        // Arrange
        service.listStub = .success([
            .init(id: 1, projectTitle: "Pr", workPackageTitle: "T", workPackageID: 2, timeSpent: DateComponents(hour: 1), comment: "Duplicate"),
            .init(id: 2, projectTitle: "Pr", workPackageTitle: "T", workPackageID: 2, timeSpent: DateComponents(hour: 2), comment: "Comment"),
            .init(id: 2, projectTitle: "Pr", workPackageTitle: "T", workPackageID: 2, timeSpent: DateComponents(hour: 3), comment: "Duplicate"),
        ])
        model = SummaryModel(service: service,
                             timeEntryID: 10,
                             userID: 5,
                             taskHref: "task/2",
                             projectHref: "project",
                             timeSpent: DateComponents(),
                             taskTitle: "title",
                             projectTitle: "projectTitle",
                             comment: "comment"
        )
        var completionCalled = false
        
        // Act
        model.loadCommentSuggestions {
            completionCalled = true
        }
        
        // Assert
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(model.commentSuggestions.count, 2)
        XCTAssertTrue(model.commentSuggestions.contains("Comment"))
        XCTAssertTrue(model.commentSuggestions.contains("Duplicate"))
    }
    
    func testLoadSuggestionsFailure() {
        // Arrange
        service.listStub = .failure(NetworkError.unknownError)
        model = SummaryModel(service: service,
                             timeEntryID: 10,
                             userID: 5,
                             taskHref: "task/2",
                             projectHref: "project",
                             timeSpent: DateComponents(),
                             taskTitle: "title",
                             projectTitle: "projectTitle",
                             comment: "comment"
        )
        var completionCalled = false
        
        // Act
        model.loadCommentSuggestions {
            completionCalled = true
        }
        
        // Assert
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(model.commentSuggestions.count, 0)
    }
}
