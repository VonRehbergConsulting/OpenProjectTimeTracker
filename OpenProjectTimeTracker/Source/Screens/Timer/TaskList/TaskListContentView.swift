//
//  TaskListContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import UIKit

final class TaskListContentView: UIView {
    
    // MARK: - Subviews
    
    private lazy var taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped).disableMask()
        tableView.register(TimerListCell.self, forCellReuseIdentifier: TimerListCell.reuseIdentifier)
        tableView.tableFooterView = spinner
        return tableView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 0, height: 40))
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: - Properties
    
    var showSpinner: Bool? {
        get { taskTableView.tableFooterView?.isHidden }
        set { taskTableView.tableFooterView?.isHidden = !(newValue ?? false) }
    }
    
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
    
    // MARK: - Public methods
    
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
