//
//  TaskListDataProviderMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker

final class TaskListDataProviderMock: TaskListDataProviderProtocol {
    
    var itemCount: Int = 0
    
    var itemStub: Task?
    func item(at index: Int) -> Task? {
        return itemStub
    }
    
    var itemIdStub: Task?
    func item(id: Int, completion: @escaping (Task?) -> Void) {
        completion(itemIdStub)
    }
    
    var loadNextStub: [Int]?
    func loadNext(_ completion: @escaping ([Int]) -> Void) {
        guard let loadNextStub = loadNextStub else { return }
        completion(loadNextStub)
    }
    
    var reloadCalled = false
    func reload(_ completion: @escaping (() -> Void)) {
        reloadCalled = true
        completion()
    }
    
    
}
