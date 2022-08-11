//
//  TimerContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

final class TimerContentView: UIView {
    
    // MARK: - Constants
    
    private struct Constants {
        static let stackViewSpacing: CGFloat = 20
        static let edgeInsets: CGFloat = 16
    }
    
    // MARK: - Subviews
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(taskDetails)
        
        let subView = UIView().disableMask()
        subView.backgroundColor = .clear
        subView.addSubview(timerView)
        NSLayoutConstraint.activate([
            timerView.widthAnchor.constraint(equalTo: subView.widthAnchor, multiplier: 0.7),
            timerView.heightAnchor.constraint(equalTo: subView.heightAnchor),
            timerView.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: subView.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(subView)
        stackView.addArrangedSubview(hintLabel)
        
        return stackView
    }()
    
    private lazy var taskDetails: TaskDetailView = {
        let view = TaskDetailView().disableMask()
        return view
    }()
    
    private lazy var timerView: TimerView = {
        let timerView = TimerView().disableMask()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(timerOnTap))
        timerView.addGestureRecognizer(tapGestureRecognizer)
        longPressGestureRecognizer.addTarget(self, action: #selector(timerOnLongPress))
        timerView.addGestureRecognizer(longPressGestureRecognizer)
        return timerView
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel().disableMask()
        label.numberOfLines = 2
        label.text = "Tap to pause, resume\nHold to finish"
        return label
    }()
    
    // MARK: - Properties
    
    private var longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    var taskDetailTapAction: (() -> Void)? {
        get { taskDetails.tapAction }
        set { taskDetails.tapAction = newValue }
    }
    var timerTapAction: (() -> Void)?
    var timerLongPressAction: (() -> Void)?
    
    var timerTitle: String? {
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
        backgroundColor = .systemGroupedBackground
        
        addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInsets),
            topStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInsets),
            topStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInsets),
        ])
    }
    
    // MARK: - Public methods
    
    func updateTaskData(_ task: Task) {
        taskDetails.updateData(task)
        setState(.setUp)
    }
    
    func setState(_ state: TimerState) {
        switch state {
        case .taskNotSelected:
            updateTimerView(color: Colors.inactive, isEnabled: false, text: "")
        case .setUp:
            updateTimerView(color: Colors.start, isEnabled: true, text: "Start")
        case .active:
            updateTimerView(color: Colors.pause, isEnabled: true, text: nil)
        case .paused:
            updateTimerView(color: Colors.start, isEnabled: true, text: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc private func timerOnTap() {
        timerTapAction?()
    }
    
    @objc private func timerOnLongPress() {
        if longPressGestureRecognizer.state == .began {
            timerLongPressAction?()
        }
    }
    
    // MARK: - Private helpers
    
    private func updateTimerView(color: UIColor, isEnabled: Bool, text: String?) {
        timerView.backgroundColor = color
        timerView.isUserInteractionEnabled = isEnabled
        if text != nil {
            timerView.text = text
        }
    }
}
