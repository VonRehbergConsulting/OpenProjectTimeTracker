//
//  TimeEntriesServiceTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimeEntriesServiceTests: XCTestCase {
    
    var service: TimeEntriesService!
    var requestService: RequestServiceMock!
    var factory: TimeEntriesRequestFactory!
    
    override func setUp() {
        requestService = RequestServiceMock()
        factory = TimeEntriesRequestFactory()
        service = TimeEntriesService(service: requestService, requestFactory: factory)
    }
    
    override func tearDown() {
        factory = nil
        requestService = nil
        service = nil
    }
    
    // MARK: - create
    
    func testCreateDFailure() {
        // Arrange
        requestService.sendStub = .failure(NetworkError.unknownError)
        var result: Bool = true
        
        // Act
        service.create(
            userID: 1,
            projectHref: "asd",
            workPackageHref: "dsa",
            duration: DateComponents(),
            date: Date(),
            comment: "comment") { success in
                result = success
            }
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func testCreateSuccess() {
        // Arrange
        requestService.sendStub = .success(())
        var result: Bool = false
        
        // Act
        service.create(
            userID: 1,
            projectHref: "asd",
            workPackageHref: "dsa",
            duration: DateComponents(),
            date: Date(),
            comment: "comment") { success in
                result = success
            }
        
        // Assert
        XCTAssertTrue(result)
    }
    
    // MARK: - update
    
    func testUpdateFailure() {
        // Arrange
        requestService.sendStub = .failure(NetworkError.unknownError)
        var result: Bool = true
        
        // Act
        service.update(id: 1, duration: DateComponents(), comment: "asd") { success in
            result = success
        }
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func testUpdateSuccess() {
        // Arrange
        requestService.sendStub = .success(())
        var result: Bool = false
        
        // Act
        service.update(id: 1, duration: DateComponents(), comment: "asd") { success in
            result = success
        }
        
        // Assert
        XCTAssertTrue(result)
    }
    
    // MARK: - list
    
    func testListFailure() {
        // Arrange
        requestService.sendStub = .failure(NetworkError.unknownError)
        var result: Error?
        
        // Act
        service.list(userID: 1, page: 1, date: Date(), workPackage: nil) { response in
            switch response {
            case .failure(let error):
                result = error
            case .success(_):
                XCTFail()
            }
        }
        
        // Assert
        XCTAssertNotNil(result)
    }
    
    func testListSuccess() {
        // Arrange
        let timeEntries = [
            TimeEntryListModel(id: 1, projectTitle: "title", workPackageTitle: "task", workPackageID: 2, timeSpent: DateComponents()),
            TimeEntryListModel(id: 1, projectTitle: "title", workPackageTitle: "task", workPackageID: 2, timeSpent: DateComponents())
        ]
        requestService.sendStub = .success(timeEntries)
        var result: [TimeEntryListModel]?
        
        // Act
        service.list(userID: 1, page: 1, date: Date(), workPackage: nil) { response in
            switch response {
            case .failure(_):
                XCTFail()
            case .success(let value):
                result = value
            }
        }
        
        // Assert
        XCTAssertEqual(result?.count, 2)
    }
}

