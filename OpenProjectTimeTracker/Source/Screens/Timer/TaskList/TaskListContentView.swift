//
//  TaskListContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import UIKit

protocol TaskListContentViewProtocol: AnyObject {
    
    var showSpinner: Bool? { get set }
    
    func setDelegates(dataSource: UITableViewDataSource, delegate: UITableViewDelegate)
    
    func insertItems(at indexPaths: [IndexPath])
}

final class TaskListContentView: UIView, TaskListContentViewProtocol {
    
    // MARK: - Subviews
    
    private lazy var taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped).disableMask()
        tableView.register(TimerTaskCell.self, forCellReuseIdentifier: TimerTaskCell.reuseIdentifier)
        tableView.tableFooterView = spinner
        return tableView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 0, height: 40))
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        addSubview(taskTableView)
        taskTableView.attachToSuperview()
    }
    
    // MARK: - TaskListContentViewProtocol
    
    var showSpinner: Bool? {
        get { taskTableView.tableFooterView?.isHidden }
        set { taskTableView.tableFooterView?.isHidden = !(newValue ?? false) }
    }
    
    func insertItems(at indexPaths: [IndexPath]) {
        if indexPaths.isEmpty {
            let indexPath = IndexPath(row: taskTableView.numberOfRows(inSection: 0) - 1, section: 0)
            taskTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        } else {
            taskTableView.beginUpdates()
            taskTableView.insertRows(at: indexPaths, with: .fade)
            taskTableView.endUpdates()
        }
    }
    
    func setDelegates(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        taskTableView.dataSource = dataSource
        taskTableView.delegate = delegate
    }
}
