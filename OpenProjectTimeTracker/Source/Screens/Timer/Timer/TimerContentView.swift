//
//  TimerContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerContentViewProtocol: AnyObject {
    
    var taskDetailTapAction: (() -> Void)? { get set }
    
    func updateTaskData(_ task: Task)
}

final class TimerContentView: UIView, TimerContentViewProtocol {
    
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
    
    private lazy var taskDetails: TaskDetailView = {
        let view = TaskDetailView().disableMask()
        return view
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
    
    // MARK: - Properties
    
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
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInsets),
            topStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
            topStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets)
        ])
    }
    
    // MARK: - TimerContentViewProtocol
    
    var taskDetailTapAction: (() -> Void)? {
        get { taskDetails.tapAction }
        set { taskDetails.tapAction = newValue }
    }
    
    func updateTaskData(_ task: Task) {
        taskDetails.updateData(task)
    }
}
