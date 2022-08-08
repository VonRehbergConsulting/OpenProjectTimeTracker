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
    private var isLoading = false
    private var nextPage = 1
    
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
        guard isLoading == false else { return }
        isLoading = true
        Logger.log("Loading tasks")
        service.loadTasks(id: userID, page: nextPage) { [weak self] result in
            guard let self = self else { return }
            var indexes = [Int]()
            switch result {
            case .failure(let error):
                Logger.log(event: .failure, "Can't load tasks: \(error.localizedDescription)")
            case .success(let response):
                let responseCount = response.count
                Logger.log(event: .success, "Tasks loaded: \(responseCount)")
                if responseCount > 0 {
                    self.nextPage += 1
                    let firstIndex = self.tasks.count
                    self.tasks.append(contentsOf: response)
                    for i in firstIndex..<self.tasks.count  {
                        indexes.append(i)
                    }
                }
            }
            self.isLoading = false
            completion(indexes)
        }
    }
}
