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
    
    func routeToTaskList(_ completion: @escaping (Task) -> Void)
    
    func routeToSummary(taskHref: String,
                        projectHref: String,
                        timeSpent: Date,
                        taskTitle: String?,
                        projectTitle: String?,
                        _ completion: @escaping () -> Void)
}

class TimerCoordinator: Coordinator,
                        TimerCoordinatorProtocol,
                        TimerCoordinatorOutput {
    
    // MARK: - Properties
    
    private let screenFactory: TimerScreenFactoryProtocol
    private let router: CoordinatorRouterProtocol
    private let service: UserServiceProtocol
    private var userID: Int = 0
    
    // MARK: - TimerCoordinatorOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Lifecycle
    
    init(screenFactory: TimerScreenFactoryProtocol,
         router: CoordinatorRouterProtocol,
         service: UserServiceProtocol) {
        self.screenFactory = screenFactory
        self.router = router
        self.service = service
    }
    
    // MARK: - TimerCoordinatorProtocol
    
    func start() {
        Logger.log("Starting timer flow")
        Logger.log("Requesting user id")
        service.getUserID() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let id):
                Logger.log(event: .success, "User id recieved")
                self.userID = id
                self.showTimerScreen()
            case.failure(let error):
                Logger.log(event: .error, "Unable to get user id: \(error)")
                self.finishFlow?()
            }
        }
    }
    
    // MARK: - TimerCoordinatorProtocol
    
    func routeToTaskList(_ completion: @escaping (Task) -> Void) {
        let viewController = screenFactory.createTaskListScreen(userID: userID)
        viewController.finishFlow = { [weak self] task in
            self?.router.pop(animated: true)
            completion(task)
        }
        router.push(viewController, animated: true)
    }
    
    func routeToSummary(taskHref: String,
                        projectHref: String,
                        timeSpent: Date,
                        taskTitle: String?,
                        projectTitle: String?,
                        _ completion: @escaping () -> Void) {
        let viewController = screenFactory.createSummaryScreen(userID: userID,
                                                               taskHref: taskHref,
                                                               projectHref: projectHref,
                                                               timeSpent: timeSpent,
                                                               taskTitle: taskTitle,
                                                               projectTitle: projectTitle)
        viewController.finishFlow = { [weak self] in
            self?.router.pop(animated: true)
            completion()
        }
        router.push(viewController, animated: true)
    }
    
    // MARK: - Private helpers
    
    private func showTimerScreen() {
        let viewController = screenFactory.createTimerScreen(userID: userID)
        viewController.coordinator = self
        router.transition(to: viewController)
    }
}
