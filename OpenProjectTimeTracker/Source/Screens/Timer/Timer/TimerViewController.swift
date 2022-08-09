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
    
    var contentView: TimerContentViewProtocol? { view as? TimerContentViewProtocol }
    
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
    }
    
    private func updateTask(_ task: Task) {
        presenter?.updateTaskData(task)
        contentView?.updateTaskData(task)
    }
}
