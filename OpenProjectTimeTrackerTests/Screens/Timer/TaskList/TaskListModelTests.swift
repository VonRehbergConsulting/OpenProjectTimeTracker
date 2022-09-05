//
//  TaskListModelTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TaskListModelTests: XCTestCase {
    
    var model: TaskListModel!
    var taskProvider: TaskListDataProviderMock!
    var timeEntriesProvider: TimeEntriesDataProviderMock!
    
    override func setUp() {
        taskProvider = TaskListDataProviderMock()
        timeEntriesProvider = TimeEntriesDataProviderMock()
        model = TaskListModel(taskDataProvider: taskProvider, timeEntryDataProvider: timeEntriesProvider)
    }
    
    override func tearDown() {
        model = nil
        taskProvider = nil
        timeEntriesProvider = nil
    }
    
    func testTaskCount() {
        // Arrange
        taskProvider.itemCount = 4
        
        // Assert
        XCTAssertEqual(model.taskCount, 4)
    }
    
    func testTimeEntryCount() {
        // Arrange
        timeEntriesProvider.itemCount = 4
        
        // Assert
        XCTAssertEqual(model.timeEntryCount, 4)
    }
    
    func testTask() {
        // Arrange
        let taskStub = Task(selfHref: "self", subject: "subj", projectHref: "proj")
        taskProvider.itemStub = taskStub
        
        // Act
        let task = model.task(at: 0)
        
        // Assert
        XCTAssertEqual(task?.selfHref, taskStub.selfHref)
    }
    
    func testTaskWithID() {
        // Arrange
        let taskStub = Task(selfHref: "self", subject: "subj", projectHref: "proj")
        taskProvider.itemIdStub = taskStub
        
        // Act
        var task: Task?
        model.task(id: 0) { result in
            task = result
        }
        
        // Assert
        XCTAssertEqual(task?.selfHref, taskStub.selfHref)
    }
    
    func testTimeEntry() {
        // Arrange
        let components = Calendar.current.dateComponents([.second], from: Date())
        let timeEntryStub = TimeEntryListModel(
            id: 1,
            projectTitle: "proj",
            workPackageTitle: "task",
            workPackageID: 11,
            timeSpent: components,
            comment: "comment"
        )
        timeEntriesProvider.itemStub = timeEntryStub
        
        // Act
        let timeEntry = model.timeEntry(at: 0)
        
        // Assert
        XCTAssertEqual(timeEntry?.id, timeEntryStub.id)
    }
    
    func testLoadNextTasks() {
        // Arrange
        taskProvider.loadNextStub = [5]

        // Act
        var items: [Int]?
        model.loadNextTasks() { result in
            items = result
        }

        // Assert
        XCTAssertEqual(items, [5])
    }
    
    func testLoadNextTimeEntries() {
        // Arrange
        timeEntriesProvider.loadNextStub = [5]

        // Act
        var items: [Int]?
        model.loadNextTimeEntries() { result in
            items = result
        }

        // Assert
        XCTAssertEqual(items, [5])
    }
    
    func testReloadTasks() {
        // Act
        model.reloadTasks {}

        // Assert
        XCTAssertTrue(taskProvider.reloadCalled)
    }
    
    func testReloadTimeEntries() {
        // Act
        model.reloadTimeEntries {}

        // Assert
        XCTAssertTrue(timeEntriesProvider.reloadCalled)
    }
}
