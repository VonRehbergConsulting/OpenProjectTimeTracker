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
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TimerContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.taskDetailTapAction = { [weak self] in
            self?.coordinator?.routeToTaskList() { task in
                self?.updateTask(task)
            }
        }
        contentView?.timerButtonAction = { [weak self] in
            var dateComponents = DateComponents()
            dateComponents.hour = 2
            dateComponents.minute = 43
            dateComponents.second = 21
            dateComponents.calendar = Calendar.current
            let date = dateComponents.date!
            
            self?.coordinator?.routeToSummary(taskHref: "/api/v3/work_packages/4",
                                              projectHref: "/api/v3/projects/1",
                                              timeSpent: date,
                                              taskTitle: "Do some cool staff",
                                              projectTitle: "Cool project") {}
        }
    }
    
    private func updateTask(_ task: Task) {
        presenter?.updateTaskData(task)
        contentView?.updateTaskData(task)
    }
}
