//
//  TaskListPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    
    var taskCount: Int { get }
    
    func item(at indexPath: IndexPath) -> TimerTaskCell.Configuration?
    func task(at indexPath: IndexPath) -> Task?
    
    func loadTasks(_ completion: @escaping ([IndexPath]) -> Void)
}

final class TaskListPresenter: TaskListPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: TaskListViewProtocol?
    var model: TaskListModelProtocol?
    
    // MARK: - TaskListPresenterProtocol
    
    var taskCount: Int {
        model?.taskCount ?? 0
    }
    
    func item(at indexPath: IndexPath) -> TimerTaskCell.Configuration? {
        guard let task = model?.item(at: indexPath.row) else { return nil }
        let item = TimerTaskCell.Configuration(subject: task.subject)
        return item
    }
    
    func task(at indexPath: IndexPath) -> Task? {
        return model?.item(at: indexPath.row)
    }
    
    func loadTasks(_ completion: @escaping ([IndexPath]) -> Void) {
        model?.loadTasks { indexes in
            let indexPaths = indexes.compactMap { IndexPath(row: $0, section: 0) }
            completion(indexPaths)
        }
    }
    
}
