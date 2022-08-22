//
//  TaskServiceMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker

final class TaskServiceMock: TaskServiceProtocol {
    
    var taskStub: Result<Task, Error>?
    func task(id: Int, _ completion: @escaping (Result<Task, Error>) -> Void) {
        guard let taskStub = taskStub else { return }
        completion(taskStub)
    }
    
    var listStub: Result<[Task], Error>?
    func list(userID: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let listStub = listStub else { return }
        completion(listStub)
    }
}

