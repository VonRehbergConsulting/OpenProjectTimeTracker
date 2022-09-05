//
//  TaskListDataProviderTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TaskListDataProviderTests: XCTestCase {
    
    var provider: TaskListDataProvider!
    var service: TaskServiceMock!
    
    override func setUp() {
        service = TaskServiceMock()
        provider = TaskListDataProvider(userID: 10, service: service)
    }
    
    override func tearDown() {
        service = nil
        provider = nil
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
        let tasks: [Task] = [
            .init(selfHref: "Self 1", subject: "Subject 1", projectHref: "Proj 1"),
            .init(selfHref: "Self 2", subject: "Subject 2", projectHref: "Proj 2"),
            .init(selfHref: "Self 3", subject: "Subject 3", projectHref: "Proj 3"),
        ]
        service.listStub = .success(tasks)
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
        XCTAssertEqual(firstResult, [0, 1, 2])
        XCTAssertEqual(secondResult, [3, 4, 5])
        XCTAssertEqual(provider.itemCount, 6)
        XCTAssertEqual(provider.item(at: 5)?.selfHref, "Self 3")
    }
    
    // MARK: - reload
    
    func testReloadFailure() {
        // Arrange
        let tasks: [Task] = [ .init(selfHref: "Self 1", subject: "Subject 1", projectHref: "Proj 1") ]
        service.listStub = .success(tasks)
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
        let tasks: [Task] = [
            .init(selfHref: "Self 1", subject: "Subject 1", projectHref: "Proj 1"),
            .init(selfHref: "Self 2", subject: "Subject 2", projectHref: "Proj 2"),
        ]
        service.listStub = .success(tasks)
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
    
    // MARK: - item
    
    func testItemFailure() {
        // Arrange
        service.taskStub = .failure(NetworkError.unknownError)
        var task: Task?
        
        // Act
        provider.item(id: 1) { result in
            task = result
        }
        
        // Assert
        XCTAssertNil(task)
    }
    
    func testItemSuccess() {
        // Arrange
        let taskStab = Task(selfHref: "Self", subject: "Subj", projectHref: "Proj")
        service.taskStub = .success(taskStab)
        var task: Task?
        
        // Act
        provider.item(id: 1) { result in
            task = result
        }
        
        // Assert
        XCTAssertEqual(task?.selfHref, "Self")
    }
}
