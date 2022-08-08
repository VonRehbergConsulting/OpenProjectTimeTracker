//
//  TimerContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerContentViewProtocol: AnyObject {
    
    var showSpinner: Bool? { get set }
    
    func setDelegates(dataSource: UITableViewDataSource, delegate: UITableViewDelegate)
    
    func insertItems(at indexPaths: [IndexPath])
}

final class TimerContentView: UIView, TimerContentViewProtocol {
    
    // MARK: - Layout constants
    
    private struct Constants {
        static let stackViewSpacing: CGFloat = 8
        static let edgeInsets: CGFloat = 16
        static let tableViewInset: CGFloat = 12
    }
    
    // MARK: - Subviews
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        
        stackView.addArrangedSubview(taskDetails)
        stackView.addArrangedSubview(timerButton)
        stackView.addArrangedSubview(pauseButton)
        return stackView
    }()
    
    private lazy var taskDetails: UILabel = {
        let label = UILabel().disableMask()
        label.text = "Current task info"
        label.backgroundColor = UIColor(red: 0.95, green: 0.75, blue: 0.75, alpha: 1)
        label.font = .systemFont(ofSize: 20)
        label.heightAnchor.constraint(equalToConstant: 120).isActive = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var timerButton: DSButton = {
        let button = DSButton().disableMask()
        button.backgroundColor = Colors.start
        button.setTitle("Start working", for: .normal)
        return button
    }()
    
    private lazy var pauseButton: DSButton = {
        let button = DSButton().disableMask()
        button.backgroundColor = Colors.inactive
        button.setTitle("Pause", for: .normal)
        return button
    }()
    
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
    
    // MARK: - Properties
    
    var showSpinner: Bool? {
        set {
            taskTableView.tableFooterView?.isHidden = !(newValue ?? false)
        }
        get {
            taskTableView.tableFooterView?.isHidden
        }
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
        backgroundColor = .systemGroupedBackground
        
        addSubview(topStackView)
        addSubview(taskTableView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInsets),
            topStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
            topStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets),
            
            taskTableView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: Constants.tableViewInset),
            taskTableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            taskTableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - TimerContentViewProtocol
    
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
