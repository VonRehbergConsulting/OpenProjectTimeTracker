//
//  TimerPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerPresenterProtocol: AnyObject {
    
    func updateTaskData(_ task: Task)
}

final class TimerPresenter: TimerPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: TimerViewProtocol?
    var model: TimerModelProtocol?
    
    // MARK: - TimerPresenterProtocol
    
    func updateTaskData(_ task: Task) {
        model?.updateTaskData(selfHref: task.selfHref, projectHref: task.projectHref)
    }
}
