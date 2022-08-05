//
//  TimerContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

final class TimerContentView: UIView {
    
    // MARK: - Layout constants
    
    private struct Constants {
        static let stackViewSpacing: CGFloat = 8
        static let edgeInsets: CGFloat = 16
    }
    
    // MARK: - Subviews
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(taskDetails)
        stackView.addArrangedSubview(timerButton)
        stackView.addArrangedSubview(pauseButton)
        return stackView
    }()
    
    private lazy var taskDetails: UILabel = {
        let label = UILabel().disableMask()
        label.text = "Some project info"
        label.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
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
        let tableView = UITableView().disableMask()
        tableView.backgroundColor = .lightGray
        return tableView
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
        
        addSubview(topStackView)
        addSubview(taskTableView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInsets),
            topStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
            topStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets),
            
            taskTableView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: Constants.edgeInsets),
            taskTableView.leftAnchor.constraint(equalTo: topStackView.leftAnchor),
            taskTableView.rightAnchor.constraint(equalTo: topStackView.rightAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.edgeInsets)
        ])
    }
}
