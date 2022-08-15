//
//  TimerContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

final class TimerContentView: UIView {
    
    enum State {
        case taskNotSelected
        case setUp
        case active
        case inactive
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let timerInset: CGFloat = 20
        static let controlsInset: CGFloat = 28
        static let controlsSpacing: CGFloat = 48
        static let edgeInsets: CGFloat = 20
    }
    
    // MARK: - Subviews
    
    private lazy var taskDetails: TaskDetailView = {
        let view = TaskDetailView().disableMask()
        return view
    }()
    
    private lazy var timerView: TimerView = {
        let timerView = TimerView().disableMask()
        return timerView
    }()
    
    private lazy var controlsStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .horizontal
        stackView.spacing = Constants.controlsSpacing
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(finishButton)
        return stackView
    }()
    
    private lazy var startButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = Colors.start
        button.addTarget(self, action: #selector(startButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var finishButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Finish", for: .normal)
        button.backgroundColor = Colors.inactive
        button.addTarget(self, action: #selector(finishButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var taskDetailTapAction: (() -> Void)? {
        get { taskDetails.tapAction }
        set { taskDetails.tapAction = newValue }
    }
    var startButtonAction: (() -> Void)?
    var finishButtonAction: (() -> Void)?
    
    private var timerTitle: String? {
        get { timerView.text }
        set { timerView.text = newValue }
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
        backgroundColor = .systemBackground
        
        addSubview(taskDetails)
        addSubview(timerView)
        addSubview(controlsStackView)
        
        NSLayoutConstraint.activate([
            taskDetails.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            taskDetails.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
            taskDetails.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets),
            
            timerView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -Constants.edgeInsets * 2),
            timerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            timerView.heightAnchor.constraint(greaterThanOrEqualTo: taskDetails.heightAnchor),
            timerView.topAnchor.constraint(equalTo: taskDetails.bottomAnchor, constant: Constants.timerInset),
            
            controlsStackView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: Constants.controlsInset),
            controlsStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
            controlsStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets),
        ])
    }
    
    // MARK: - Public methods
    
    func updateTaskData(_ task: Task) {
        taskDetails.updateData(task)
        setState(.setUp)
    }
    
    func updateTimer(hours: Int?, minutes: Int?, seconds: Int?) {
        func processNumber(_ number: Int?) -> String {
            guard let number = number else { return "00" }
            if number < 10 { return "0\(number)" }
            return number.description
        }
        let hoursStr = processNumber(hours)
        let minutesStr = processNumber(minutes)
        let secondsStr = processNumber(seconds)
        timerTitle = "\(hoursStr):\(minutesStr):\(secondsStr)"
    }
    
    func setState(_ state: State) {
        switch state {
        case .taskNotSelected:
            timerView.text = "00:00:00"
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = Colors.inactive
            finishButton.backgroundColor = Colors.inactive
        case .setUp:
            timerView.text = "00:00:00"
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = Colors.start
            finishButton.backgroundColor = Colors.inactive
        case .active:
            startButton.setTitle("Pause", for: .normal)
            startButton.backgroundColor = Colors.pause
            finishButton.backgroundColor = Colors.stop
        case .inactive:
            startButton.setTitle("Resume", for: .normal)
            startButton.backgroundColor = Colors.start
            finishButton.backgroundColor = Colors.stop
        }
    }
    
    // MARK: - Actions
    
    @objc private func startButtonOnTap() {
        startButtonAction?()
    }
    
    @objc private func finishButtonOnTap() {
        finishButtonAction?()
    }
}
