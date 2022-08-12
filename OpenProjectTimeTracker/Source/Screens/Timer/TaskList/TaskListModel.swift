//
//  TaskListModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import Foundation

protocol TaskListModelProtocol {
    
    var taskCount: Int { get }
    
    func item(at index: Int) -> Task?
    
    func loadTasks(_ completion: @escaping ([Int]) -> Void)
    func reloadTasks(_ completion: @escaping (() -> Void))
}

final class TaskListModel: TaskListModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TaskListPresenterProtocol?
    
    private let userID: Int
    private let service: TasksServiceProtocol
    
    private var tasks = [Task]()
    private var isLoading = false
    private var nextPage = 1
    
    private var preProcessHandler: (() -> Void)?
    private var clearCompletion: (() -> Void)?
    
    // MARK: -  Lifecycle
    
    init(userID: Int, service: TasksServiceProtocol) {
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
        guard isLoading == false else { return }
        isLoading = true
        Logger.log("Loading tasks")
        service.loadTasks(id: 3, page: nextPage) { [weak self] result in
            guard let self = self else { return }
            if let preProcessHandler = self.preProcessHandler {
                self.preProcessHandler = nil
                preProcessHandler()
            }
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
            if let clearCompletion = self.clearCompletion {
                self.reset(clearCompletion)
            }
        }
    }
    
    func reloadTasks(_ completion: @escaping (() -> Void)) {
        if isLoading {
            clearCompletion = completion
        }
        else {
            reset(completion)
        }
    }
    
    // MARK: - Private helpers
    
    private func reset(_ completion: @escaping (() -> Void)) {
        clearCompletion = nil
        preProcessHandler = { [weak self] in self?.tasks = [] }
        nextPage = 1
        loadTasks { _ in completion() }
    }
}
