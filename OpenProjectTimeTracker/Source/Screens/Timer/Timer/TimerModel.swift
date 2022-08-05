//
//  TimerModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerModelProtocol {
    
    var taskCount: Int { get }
    
    func item(at index: Int) -> Task?
    
    func loadTasks(_ completion: @escaping ([Int]) -> Void)
}

final class TimerModel: TimerModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TimerPresenterProtocol?
    
    private let userID: Int
    private let service: TasksServiceProtocol
    
    private var tasks = [Task]()
    
    // MARK: - Lifecycle
    
    init(userID: Int,
         service: TasksServiceProtocol) {
        self.userID = userID
        self.service = service
    }
    
    // MARK: - TimerModelProtocol
    
    var taskCount: Int {
        tasks.count
    }
    
    func item(at index: Int) -> Task? {
        if index >= 0,
           index < tasks.count {
            return tasks[index]
        } else {
            return nil
        }
    }
    
    func loadTasks(_ completion: @escaping ([Int]) -> Void) {
        // TODO: Add multithreading
        // TODO: Appending of tasks instead of setting
        service.loadTasks(id: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                Logger.log(event: .failure, "Can't load tasks: \(error.localizedDescription)")
                completion([])
            case .success(let response):
                Logger.log(event: .success, "Tasks loaded")
                self.tasks = response
                var indexes = [Int]()
                for i in 0..<response.count  {
                    indexes.append(i)
                }
                completion(indexes)
            }
        }
    }
}
