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
        setActions()
        checkInitialData()
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
            self.set(task)
        }
    }
    
    private func timerTapAction() {
        guard let presenter = presenter else {
            Logger.log(event: .error, "Can't check the state")
            return
        }
        guard presenter.task != nil,
              let isActive = presenter.isActive
        else {
            return
        }
        if isActive {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    // MARK: - Private helpers
    
    private func checkInitialData() {
        guard let task = presenter?.task,
              presenter?.timeSpent != nil,
              let isActive = presenter?.isActive
        else {
            contentView?.setState(.taskNotSelected)
            presenter?.resetTimer()
            return
        }
        contentView?.updateTaskData(task)
        if isActive {
            startTimer()
        } else {
            contentView?.setState(.inactive)
            updateViewTimer()
        }
    }
    
    private func set(_ task: Task) {
        stopTimer()
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.resetTimer()
        presenter.task = task
        contentView.updateTaskData(task)
        contentView.setState(.setUp)
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
    
    private func stopTimer() {
        guard let presenter = presenter,
              let contentView = contentView
        else {
            Logger.log(event: .error, "Can't find instances")
            return
        }
        presenter.stopTimer()
        contentView.setState(.inactive)
        stopUpdatingView()
    }
    
    private func finishTimer() {
        guard presenter?.timeSpent != nil else { return }
        stopTimer()
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
            presenter.resetTimer()
            self?.contentView?.setState(.setUp)
        }
    }
    
    private func startUpdatingView() {
        let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateViewTimer()
        }
        updateViewTimer()
        self.timer = timer
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func updateViewTimer() {
        guard let timeSpent = self.presenter?.timeSpent
        else {
            Logger.log(event: .error, "Can't get time interval")
            return
        }
        contentView?.updateTimer(hours: timeSpent.hour, minutes: timeSpent.minute, seconds: timeSpent.second)
    }
    
    private func stopUpdatingView() {
        timer?.invalidate()
    }
}
