//
//  TimerCoordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol TimerCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

protocol TimerCoordinatorProtocol: AnyObject {
    
    func handleAuthorizationError()
    
    func routeToTaskList(_ completion: @escaping (Task, TimeEntryListModel?) -> Void)
    
    func routeToSummary(timeEntryID: Int?,
                        taskHref: String,
                        projectHref: String,
                        timeSpent: Date,
                        taskTitle: String?,
                        projectTitle: String?,
                        comment: String?,
                        _ completion: @escaping () -> Void)
}

class TimerCoordinator: Coordinator,
                        TimerCoordinatorProtocol,
                        TimerCoordinatorOutput {
    
    // MARK: - Properties
    
    private let screenFactory: TimerScreenFactoryProtocol
    private let router: CoordinatorRouterProtocol
    private let timerDataStorage: TimerDataStorageProtocol
    
    // MARK: - TimerCoordinatorOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Lifecycle
    
    init(screenFactory: TimerScreenFactoryProtocol,
         router: CoordinatorRouterProtocol,
         timerDataStorage: TimerDataStorageProtocol
    ) {
        self.screenFactory = screenFactory
        self.router = router
        self.timerDataStorage = timerDataStorage
    }
    
    // MARK: - TimerCoordinatorProtocol
    
    func start() {
        Logger.log("Starting timer flow")
        guard let userID = timerDataStorage.userID else {
            handleAuthorizationError()
            return
        }
        let viewController = screenFactory.createTimerScreen(userID: userID)
        viewController.coordinator = self
        router.transition(to: viewController)
    }
    
    // MARK: - TimerCoordinatorProtocol
    
    func handleAuthorizationError() {
        timerDataStorage.clear()
        finishFlow?()
    }
    
    func routeToTaskList(_ completion: @escaping (Task, TimeEntryListModel?) -> Void) {
        guard let userID = timerDataStorage.userID else {
            handleAuthorizationError()
            return
        }
        let viewController = screenFactory.createTaskListScreen(userID: userID)
        viewController.finishFlow = { [weak self] task, timeEntry in
            self?.router.pop(animated: true)
            completion(task, timeEntry)
        }
        router.push(viewController, animated: true)
    }
    
    func routeToSummary(timeEntryID: Int?,
                        taskHref: String,
                        projectHref: String,
                        timeSpent: Date,
                        taskTitle: String?,
                        projectTitle: String?,
                        comment: String?,
                        _ completion: @escaping () -> Void) {
        guard let userID = timerDataStorage.userID else {
            handleAuthorizationError()
            return
        }
        let viewController = screenFactory.createSummaryScreen(timeEntryID: timeEntryID,
                                                               userID: userID,
                                                               taskHref: taskHref,
                                                               projectHref: projectHref,
                                                               timeSpent: timeSpent,
                                                               taskTitle: taskTitle,
                                                               projectTitle: projectTitle,
                                                               comment: comment
        )
        viewController.finishFlow = { [weak self] in
            self?.router.pop(animated: true)
            completion()
        }
        router.push(viewController, animated: true)
    }
}
