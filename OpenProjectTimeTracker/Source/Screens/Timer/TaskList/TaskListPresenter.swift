//
//  TaskListPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    
    var modelType: TaskListPresenter.ModelType { get set }
    var itemsCount: Int { get }
    var timeSpent: String { get }
    
    func item(at indexPath: IndexPath) -> TaskListCell.Configuration?
    func outputData(at indexPath: IndexPath, _ completion: @escaping (Task?, TimeEntryListModel?) -> Void)
    
    func loadItems(_ completion: @escaping ([IndexPath]) -> Void)
    func reloadItems(_ completion: @escaping (() -> Void))
}

final class TaskListPresenter: TaskListPresenterProtocol {
    
    enum ModelType: Int {
        case task = 0
        case timeEntry = 1
    }
    
    // MARK: - Properties
    
    weak var view: TaskListViewProtocol?
    var model: TaskListModelProtocol?
    
    // MARK: - TaskListPresenterProtocol
    
    var modelType: ModelType = .task
    
    var itemsCount: Int {
        switch modelType {
        case .task:
            return model?.taskCount ?? 0
        case .timeEntry:
            return model?.timeEntryCount ?? 0
        }
    }
    
    var timeSpent: String { model?.timeSpent.shortClockTime ?? "" }
    
    func item(at indexPath: IndexPath) -> TaskListCell.Configuration? {
        switch modelType {
        case .task:
            guard let task = model?.task(at: indexPath.row) else { return nil }
            let title = task.subject
            let subtitle = task.projectTitle ?? ""
            let content = "Priority: \(task.prioriry ?? "")"
            let detail = "\(task.status ?? "")"
            let item = TaskListCell.Configuration(title: title, subtitle: subtitle, content: content, detail: detail)
            return item
        case .timeEntry:
            guard let timeEntry = model?.timeEntry(at: indexPath.row) else { return nil }
            let title = timeEntry.workPackageTitle
            let subtitle = timeEntry.projectTitle
            var content = "\(timeEntry.comment ?? "")"
            if content.isEmpty { content = "No comment" }
            let detail = "\(timeEntry.timeSpent.shortClockTime)"
            let item = TaskListCell.Configuration(title: title, subtitle: subtitle, content: content, detail: detail)
            return item
        }
    }
    
    func outputData(at indexPath: IndexPath, _ completion: @escaping (Task?, TimeEntryListModel?) -> Void) {
        switch modelType {
        case .task:
            completion(model?.task(at: indexPath.row), nil)
        case .timeEntry:
            guard let model = model,
                  let timeEntry = model.timeEntry(at: indexPath.row)
            else {
                completion(nil, nil)
                return
            }
            model.task(id: timeEntry.workPackageID) { task in
                completion(task, timeEntry)
            }
        }
    }
    
    
    func loadItems(_ completion: @escaping ([IndexPath]) -> Void) {
        switch modelType {
        case .task:
            model?.loadNextTasks { indexes in
                let indexPaths = indexes.compactMap { IndexPath(row: $0, section: 0) }
                completion(indexPaths)
            }
        case .timeEntry:
            model?.loadNextTimeEntries { indexes in
                let indexPaths = indexes.compactMap { IndexPath(row: $0, section: 0) }
                completion(indexPaths)
            }
        }
    }
    
    func reloadItems(_ completion: @escaping (() -> Void)) {
        switch modelType {
        case .task:
            model?.reloadTasks(completion)
        case .timeEntry:
            model?.reloadTimeEntries(completion)
        }
    }
}
