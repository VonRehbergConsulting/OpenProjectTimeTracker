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
    
    func createSummaryScreen(timeEntryID: Int?,
                             userID: Int,
                             taskHref: String,
                             projectHref: String,
                             timeSpent: Date,
                             taskTitle: String?,
                             projectTitle: String?) -> SummaryViewController
}

final class TimerScreenFactory: TimerScreenFactoryProtocol {
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    private let timerDataStorage: TimerDataStorageProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol, timerDataStorage: TimerDataStorageProtocol) {
        self.service = service
        self.timerDataStorage = timerDataStorage
    }
    
    // MARK: - TimerScreenFactoryProtocol
    
    func createTimerScreen(userID: Int) -> TimerViewController {
        let viewController = TimerViewController()
        let presenter = TimerPresenter()
        
        let model = TimerModel(userID: userID, storage: timerDataStorage)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
    
    func createTaskListScreen(userID: Int) -> TaskListViewController {
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        
        let requestFactory = WorkPackagesRequestFactory()
        let taskService = TasksService(service: service, requestFactory: requestFactory)
        let model = TaskListModel(userID: userID, service: taskService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
    
    func createSummaryScreen(timeEntryID: Int?,
                             userID: Int,
                             taskHref: String,
                             projectHref: String,
                             timeSpent: Date,
                             taskTitle: String?,
                             projectTitle: String?) -> SummaryViewController {
        let viewController = SummaryViewController()
        let presenter = SummaryPresenter()
        
        let requestFactory = TimeEntriesRequestFactory()
        let timeEntriesService = TimeEntriesService(service: service, requestFactory: requestFactory)
        let model = SummaryModel(service: timeEntriesService,
                                 timeEntryID: timeEntryID,
                                 userID: userID,
                                 taskHref: taskHref,
                                 projectHref: projectHref,
                                 timeSpent: timeSpent,
                                 taskTitle: taskTitle,
                                 projectTitle: projectTitle)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
}
