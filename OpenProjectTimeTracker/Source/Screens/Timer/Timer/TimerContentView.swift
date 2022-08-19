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
        static let topInset: CGFloat = -80
        static let timerInset: CGFloat = 40
        static let controlsInset: CGFloat = 20
        static let edgeInsets: CGFloat = 20
        static let buttonWidthMultiplier: CGFloat = 0.4
    }
    
    // MARK: - Subviews
    
    private lazy var elementsView: UIView = {
        let view = UIView().disableMask()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var taskDetails: TaskDetailView = {
        let view = TaskDetailView().disableMask()
        return view
    }()
    
    private lazy var timerView: TimerView = {
        let timerView = TimerView().disableMask()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(timerViewOnTap))
        timerView.addGestureRecognizer(gestureRecognizer)
        return timerView
    }()
    
    private lazy var controlsStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(finishButton)
        return stackView
    }()
    
    private lazy var startButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(startButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var finishButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Finish", for: .normal)
        button.addTarget(self, action: #selector(finishButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    
    var taskDetailTapAction: (() -> Void)? {
        get { taskDetails.tapAction }
        set { taskDetails.tapAction = newValue }
    }
    var timerTapAction: (() -> Void)?
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
        
        addSubview(elementsView)
        elementsView.addSubview(taskDetails)
        elementsView.addSubview(timerView)
        elementsView.addSubview(controlsStackView)
        
        NSLayoutConstraint.activate([
            elementsView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            elementsView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.topInset),
            elementsView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            timerView.topAnchor.constraint(equalTo: elementsView.topAnchor),
            timerView.centerXAnchor.constraint(equalTo: elementsView.centerXAnchor),
            timerView.widthAnchor.constraint(equalTo: elementsView.widthAnchor, constant: -Constants.edgeInsets * 2),
            timerView.heightAnchor.constraint(greaterThanOrEqualTo: timerView.widthAnchor, multiplier: 0.25),
            
            taskDetails.topAnchor.constraint(equalTo: timerView.bottomAnchor),
            taskDetails.leftAnchor.constraint(equalTo: elementsView.leftAnchor, constant: Constants.edgeInsets),
            taskDetails.rightAnchor.constraint(equalTo: elementsView.rightAnchor, constant: -Constants.edgeInsets),
            
            startButton.widthAnchor.constraint(equalTo: elementsView.widthAnchor, multiplier: Constants.buttonWidthMultiplier),
            finishButton.widthAnchor.constraint(equalTo: startButton.widthAnchor),
            controlsStackView.topAnchor.constraint(equalTo: taskDetails.bottomAnchor, constant: Constants.controlsInset),
            controlsStackView.centerXAnchor.constraint(equalTo: elementsView.centerXAnchor),
            controlsStackView.widthAnchor.constraint(equalTo: taskDetails.widthAnchor),
            controlsStackView.bottomAnchor.constraint(equalTo: elementsView.bottomAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            taskDetails.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
//            taskDetails.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
//            taskDetails.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets),
//
//            timerView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -Constants.edgeInsets * 4),
//            timerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
//            timerView.heightAnchor.constraint(greaterThanOrEqualTo: taskDetails.heightAnchor),
//            timerView.topAnchor.constraint(equalTo: taskDetails.bottomAnchor, constant: Constants.timerInset),
//
//            startButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.buttonWidthMultiplier),
//            finishButton.widthAnchor.constraint(equalTo: startButton.widthAnchor),
//            controlsStackView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: Constants.controlsInset),
//            controlsStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
//            controlsStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.controlsStackWidthMultiplier),
//        ])
    }
    
    // MARK: - Public methods
    
    func updateTaskData(_ task: Task) {
        taskDetails.updateData(task)
        setState(.setUp)
    }
    
    func updateTimer(_ dateComponents: DateComponents) {
        timerTitle = dateComponents.clockTime
    }
    
    func setState(_ state: State) {
        switch state {
        case .taskNotSelected:
            timerView.text = "00:00:00"
            startButton.setTitle("Start", for: .normal)
            startButton.style = .inactive
            finishButton.style = .inactive
        case .setUp:
            timerView.text = "00:00:00"
            startButton.setTitle("Start", for: .normal)
            startButton.style = .normal
            finishButton.style = .inactive
        case .active:
            startButton.setTitle("Pause", for: .normal)
            startButton.style = .normal
            finishButton.style = .normal
        case .inactive:
            startButton.setTitle("Resume", for: .normal)
            startButton.style = .normal
            finishButton.style = .normal
        }
    }
    
    // MARK: - Actions
    
    @objc private func startButtonOnTap() {
        startButtonAction?()
    }
    
    @objc private func finishButtonOnTap() {
        finishButtonAction?()
    }
    
    @objc private func timerViewOnTap() {
        timerTapAction?()
    }
}
