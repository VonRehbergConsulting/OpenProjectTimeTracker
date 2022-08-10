//
//  TimerViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerViewProtocol: AnyObject {
    
}

final class TimerViewController: UIViewController, TimerViewProtocol {
    
    // MARK: - Properties
    
    var contentView: TimerContentView? { view as? TimerContentView }
    
    weak var coordinator: TimerCoordinatorProtocol?
    var presenter: TimerPresenterProtocol?
    
    var timer: Timer?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TimerContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.setState(presenter?.state ?? .taskNotSelected)
        setActions()
    }
    
    private func setActions() {
        contentView?.taskDetailTapAction = { [weak self] in
            self?.taskDetailTapAction()
        }
        contentView?.timerTapAction = { [weak self] in
            self?.timerTapAction()
        }
        contentView?.timerLongPressAction = { [weak self] in
            self?.finishTimer()
        }
    }
    
    // MARK: - Actions
    
    private func taskDetailTapAction() {
        coordinator?.routeToTaskList() { [weak self] task in
            guard let self = self else { return }
            self.setUp(task)
        }
    }
    
    private func timerTapAction() {
        guard let state = presenter?.state else {
            Logger.log(event: .error, "Can't get state")
            return
        }
        switch state {
        case .taskNotSelected:
            break
        case .setUp:
            startTimer()
        case .active:
            pauseTimer()
        case .paused:
            resumeTimer()
        }
    }
    
    // MARK: - Private helpers
    
    private func setUp(_ task: Task) {
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.updateTaskData(task)
        contentView.updateTaskData(task)
        contentView.setState(.setUp)
    }
    
    private func startTimer() {
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.startTimer()
        contentView.setState(.active)
        createTimer()
    }
    
    private func pauseTimer() {
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.pauseTimer()
        contentView.setState(.paused)
        timer?.invalidate()
    }
    
    private func resumeTimer() {
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.resumeTimer()
        contentView.setState(.active)
        createTimer()
    }
    
    private func finishTimer() {
        var dateComponents = DateComponents()
        dateComponents.hour = 2
        dateComponents.minute = 43
        dateComponents.second = 21
        dateComponents.calendar = Calendar.current
        let date = dateComponents.date!
        
        coordinator?.routeToSummary(taskHref: "/api/v3/work_packages/4",
                                    projectHref: "/api/v3/projects/1",
                                    timeSpent: date,
                                    taskTitle: "Do some cool staff",
                                    projectTitle: "Cool project") {}
    }
    
    private func createTimer() {
        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self,
                  let timeSpent = self.presenter?.timeSpent
            else {
                Logger.log(event: .error, "Can't get time interval")
                return
            }
            self.contentView?.timerTitle = timeSpent.description
        }
        self.timer = timer
        RunLoop.current.add(timer, forMode: .common)
    }
}
