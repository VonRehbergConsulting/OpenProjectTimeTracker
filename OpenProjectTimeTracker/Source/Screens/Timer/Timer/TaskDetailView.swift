//
//  TaskDetailView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import UIKit

final class TaskDetailView: ShadowView {
    
    // MARK: - Constants
    
    private struct Constants {
        static let emptyField: String = "-"
        static let stackViewSpacing: CGFloat = 4
        static let edgeInsets: CGFloat = 12
    }
    
    // MARK: - Subviews
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel().disableMask()
        label.text = "Press to select task"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(projectLabel)
        stackView.addArrangedSubview(priorityLabel)
        stackView.addArrangedSubview(statusLabel)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var projectLabel: UILabel = {
        let label = UILabel().disableMask()
        return label
    }()
    
    private lazy var priorityLabel: UILabel = {
        let label = UILabel().disableMask()
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel().disableMask()
        return label
    }()
    
    // MARK: - Properties
    
    var tapAction: (() -> Void)?
    
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
        addSubview(labelsStack)
        addSubview(emptyLabel)
        labelsStack.attachToSuperview(inset: Constants.edgeInsets)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        setVisibility(isEmpty: true)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Public methods
    
    func updateData(_ task: Task?) {
        if let task = task {
            titleLabel.text = task.subject
            projectLabel.text = "Project: \(task.projectTitle ?? Constants.emptyField)"
            priorityLabel.text = "Priority: \(task.prioriry ?? Constants.emptyField)"
            statusLabel.text = "Status: \(task.status ?? Constants.emptyField)"
        }
        setVisibility(isEmpty: task == nil)
    }
    
    // MARK: - Actions
    
    @objc private func onTap() {
        tapAction?()
    }
    
    // MARK: - Private helpers
    
    private func setVisibility(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        if isEmpty {
            titleLabel.text = " "
            projectLabel.text = " "
            priorityLabel.text = " "
            statusLabel.text = " "
        }
    }
}
