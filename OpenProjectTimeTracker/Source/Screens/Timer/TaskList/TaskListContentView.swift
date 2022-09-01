//
//  TaskListContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import UIKit

final class TaskListContentView: UIView {
    
    // MARK: - Constants
    
    private struct Constants {
        static let edgeInset: CGFloat = 16
        static let segmentedControlEdgeInset: CGFloat = 20
    }
    
    // MARK: - Subviews
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Tasks", "Recent work"]).disableMask()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControllChangedValue), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var tableView: InfiniteTableView = {
        let tableView = InfiniteTableView(frame: .zero).disableMask()
        tableView.backgroundColor = .clear
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    var refreshControlAction: (() -> Void)? {
        get { tableView.refreshControlAction }
        set { tableView.refreshControlAction = newValue }
    }
    
    var segmentedControlAction: ((Int) -> Void)?
    
    var tableViewContentInset: UIEdgeInsets {
        get { tableView.contentInset }
        set { tableView.contentInset = newValue }
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
        backgroundColor = Colors.groupedBackground
        addSubview(tableView)
        tableView.attachToSuperview()
        
        let insetsView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 60))
        insetsView.backgroundColor = .clear
        insetsView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: insetsView.topAnchor, constant: Constants.edgeInset),
            segmentedControl.leftAnchor.constraint(equalTo: insetsView.leftAnchor, constant: Constants.segmentedControlEdgeInset),
            segmentedControl.rightAnchor.constraint(equalTo: insetsView.rightAnchor, constant: -Constants.segmentedControlEdgeInset),
            segmentedControl.bottomAnchor.constraint(equalTo: insetsView.bottomAnchor, constant: -Constants.edgeInset)
        ])
        tableView.tableHeaderView = insetsView
    }
    
    // MARK: - Public methods
    
    func setDelegates(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    func startLoading() {
        tableView.startLoading()
    }
    
    func finishLoading(_ indexPaths: [IndexPath]) {
        tableView.finishLoading(indexPaths)
    }
    
    func finishRefreshing() {
        tableView.finishRefreshing()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func segmentedControllChangedValue() {
        segmentedControlAction?(segmentedControl.selectedSegmentIndex)
    }
}
