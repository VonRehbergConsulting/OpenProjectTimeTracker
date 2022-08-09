//
//  TimerScreenFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerScreenFactoryProtocol {
    
    func createTimerScreen(userID: Int) -> TimerViewController
    
    func createTaskListScreen(userID: Int) -> TaskListViewController
    
}

final class TimerScreenFactory: TimerScreenFactoryProtocol {
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - TimerScreenFactoryProtocol
    
    func createTimerScreen(userID: Int) -> TimerViewController {
        let viewController = TimerViewController()
        let presenter = TimerPresenter()
        let model = TimerModel(userID: userID)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
    
    func createTaskListScreen(userID: Int) -> TaskListViewController {
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        
        let taskService = TasksService(service: service)
        let model = TaskListModel(userID: userID, service: taskService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
}
