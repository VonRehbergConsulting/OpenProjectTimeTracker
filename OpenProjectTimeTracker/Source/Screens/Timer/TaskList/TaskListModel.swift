//
//  TaskListModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

// Arrange

// Act

// Assert

import Foundation

protocol TaskListModelProtocol {
    
    var taskCount: Int { get }
    var timeEntryCount: Int { get }
    var timeSpent: Double { get }
    
    func task(at index: Int) -> Task?
    func task(id: Int, completion: @escaping (Task?) -> Void)
    func timeEntry(at index: Int) -> TimeEntryListModel?
    
    func loadNextTasks(_ completion: @escaping ([Int]) -> Void)
    func loadNextTimeEntries(_ completion: @escaping ([Int]) -> Void)
    
    func reloadTasks(_ completion: @escaping (() -> Void))
    func reloadTimeEntries(_ completion: @escaping (() -> Void))
}

final class TaskListModel: TaskListModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TaskListPresenterProtocol?
    
    private let taskDataProvider: TaskListDataProviderProtocol
    private let timeEntryDataProvider: TimeEntriesListDataProviderProtocol
    
    // MARK: Lifecycle
    
    init(taskDataProvider: TaskListDataProviderProtocol,
         timeEntryDataProvider: TimeEntriesListDataProviderProtocol
    ) {
        self.taskDataProvider = taskDataProvider
        self.timeEntryDataProvider = timeEntryDataProvider
    }
    
    // MARK: - TaskListModelProtocol
    
    var taskCount: Int { taskDataProvider.itemCount }
    var timeEntryCount: Int { timeEntryDataProvider.itemCount }
    var timeSpent: Double { timeEntryDataProvider.timeSpent }
    
    func task(at index: Int) -> Task? {
        taskDataProvider.item(at: index)
    }
    func task(id: Int, completion: @escaping (Task?) -> Void) {
        taskDataProvider.item(id: id, completion: completion)
    }
    func timeEntry(at index: Int) -> TimeEntryListModel? {
        timeEntryDataProvider.item(at: index)
    }
    
    func loadNextTasks(_ completion: @escaping ([Int]) -> Void) {
        taskDataProvider.loadNext(completion)
    }
    
    func loadNextTimeEntries(_ completion: @escaping ([Int]) -> Void) {
        timeEntryDataProvider.loadNext(completion)
    }
    
    func reloadTasks(_ completion: @escaping (() -> Void)) {
        taskDataProvider.reload(completion)
    }
    
    func reloadTimeEntries(_ completion: @escaping (() -> Void)) {
        timeEntryDataProvider.reload(completion)
    }
}
