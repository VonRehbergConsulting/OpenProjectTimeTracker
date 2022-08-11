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
        presenter.task = task
        contentView.updateTaskData(task)
    }
    
    // Status changes
    
    private func startTimer() {
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.startTimer()
        contentView.setState(.active)
        startUpdatingView()
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
        stopUpdatingView()
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
        startUpdatingView()
    }
    
    private func finishTimer() {
        pauseTimer()
        guard let presenter = presenter,
              let components = presenter.timeSpent,
              let date = components.date,
              let task = presenter.task
        else {
            Logger.log(event: .error, "Can't get data")
            return
        }
        coordinator?.routeToSummary(taskHref: task.selfHref,
                                    projectHref: task.projectHref,
                                    timeSpent: date,
                                    taskTitle: task.subject,
                                    projectTitle: task.projectTitle) { [weak self, presenter] in
            presenter.reset()
            self?.contentView?.setState(.setUp)
        }
    }
    
    // NSTimer
    
    private func startUpdatingView() {
        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.fireTimer(timer)
        }
        fireTimer(timer)
        self.timer = timer
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func fireTimer(_ timer: Timer) {
        guard let timeSpent = self.presenter?.timeSpent
        else {
            Logger.log(event: .error, "Can't get time interval")
            return
        }
        let hours = timeSpent.hour?.description ?? "00"
        let minutes = timeSpent.minute?.description ?? "00"
        let seconds = timeSpent.second?.description ?? "00"
        self.contentView?.timerTitle = "\(hours):\(minutes):\(seconds)"
    }
    
    private func stopUpdatingView() {
        timer?.invalidate()
    }
}
