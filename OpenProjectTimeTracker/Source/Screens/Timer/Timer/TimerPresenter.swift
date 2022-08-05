//
//  TimerPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerPresenterProtocol: AnyObject {
    
    var taskCount: Int { get }
    
    func item(at indexPath: IndexPath) -> TimerTaskCell.Configuration?
    
    func loadTasks(_ completion: @escaping ([IndexPath]) -> Void)
}

final class TimerPresenter: TimerPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: TimerViewProtocol?
    var model: TimerModelProtocol?
    
    // MARK: - TimerPresenterProtocol
    
    var taskCount: Int {
        model?.taskCount ?? 0
    }
    
    func item(at indexPath: IndexPath) -> TimerTaskCell.Configuration? {
        guard let task = model?.item(at: indexPath.row) else { return nil }
        let item = TimerTaskCell.Configuration(subject: task.subject)
        return item
    }
    
    func loadTasks(_ completion: @escaping ([IndexPath]) -> Void) {
        model?.loadTasks { indexes in
            let indexPaths = indexes.compactMap { IndexPath(row: $0, section: 0) }
            completion(indexPaths)
        }
    }
    
}
