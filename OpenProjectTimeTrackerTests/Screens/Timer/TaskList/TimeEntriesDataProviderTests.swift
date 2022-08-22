//
//  TimeEntriesDataProviderTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TimeEntriesDataProviderTests: XCTestCase {
    
    var provider: TimeEntriesDataProvider!
    var service: TimeEntriesServiceMock!
    
    override func setUp() {
        service = TimeEntriesServiceMock()
        provider = TimeEntriesDataProvider(userID: 10, service: service)
    }
    
    override func tearDown() {
        provider = nil
        service = nil
    }
    
    // MARK: - loadNext
    
    func testLoadNextFailure() {
        // Arrange
        service.listStub = .failure(NetworkError.unknownError)
        var items: [Int] = []
        
        // Act
        provider.loadNext() { result in
            items = result
        }
        
        // Assert
        XCTAssertEqual(items.count, 0)
        XCTAssertEqual(provider.itemCount, 0)
        XCTAssertNil(provider.item(at: 1))
    }
    
    func testLoadNextSuccess() {
        // Arrange
        let timeSpent = Calendar.current.dateComponents([.second], from: Date())
        let items: [TimeEntryListModel] = [
            .init(id: 1, projectTitle: "Project 1", workPackageTitle: "Taks 1", workPackageID: 11, timeSpent: timeSpent),
            .init(id: 2, projectTitle: "Project 2", workPackageTitle: "Taks 2", workPackageID: 12, timeSpent: timeSpent)
        ]
        service.listStub = .success(items)
        var firstResult: [Int] = []
        var secondResult: [Int] = []
        
        // Act
        provider.loadNext() { result in
            firstResult = result
        }
        provider.loadNext() { result in
            secondResult = result
        }
        
        // Assert
        XCTAssertEqual(firstResult, [0, 1])
        XCTAssertEqual(secondResult, [2, 3])
        XCTAssertEqual(provider.itemCount, 4)
        XCTAssertEqual(provider.item(at: 3)?.id, 2)
    }
    
    // MARK: - reload
    
    func testReloadFailure() {
        // Arrange
        let timeSpent = Calendar.current.dateComponents([.second], from: Date())
        let items: [TimeEntryListModel] = [
            .init(id: 1, projectTitle: "Project 1", workPackageTitle: "Taks 1", workPackageID: 11, timeSpent: timeSpent)
        ]
        service.listStub = .success(items)
        provider.loadNext() { _ in }
        service.listStub = .failure(NetworkError.unknownError)
        var completionCalled = false
        
        // Act
        provider.reload {
            completionCalled = true
        }
        
        // Assert
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(provider.itemCount, 0)
    }
    
    func testReloadSuccess() {
        // Arrange
        let timeSpent = Calendar.current.dateComponents([.second], from: Date())
        let items: [TimeEntryListModel] = [
            .init(id: 1, projectTitle: "Project 1", workPackageTitle: "Taks 1", workPackageID: 11, timeSpent: timeSpent),
            .init(id: 2, projectTitle: "Project 2", workPackageTitle: "Taks 2", workPackageID: 12, timeSpent: timeSpent)
        ]
        service.listStub = .success(items)
        provider.loadNext() { _ in }
        var completionCalled = false
        
        // Act
        provider.reload {
            completionCalled = true
        }
        
        // Assert
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(provider.itemCount, 2)
    }
}
