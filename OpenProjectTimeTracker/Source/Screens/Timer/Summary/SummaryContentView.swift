//
//  SummaryContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import UIKit

final class SummaryContentView: UIView {
    
    // MARK: - Constants
    
    private struct Constants {
        static let stackViewSpacing: CGFloat = 4
        static let edgeInset: CGFloat = 16
        
        static let taskLabel = "Task: "
        static let projectLabel = "Project: "
        static let timeLabel = "Time spent: "
    }
    
    // MARK: - Subviews
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(projectLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(saveButton)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 20)
        label.text = Constants.taskLabel
        return label
    }()
    
    private lazy var projectLabel: UILabel = {
        let label = UILabel().disableMask()
        label.text = Constants.projectLabel
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel().disableMask()
        label.text = Constants.timeLabel
        return label
    }()
    
    private lazy var saveButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var saveButtonAction: (() -> Void)?
    
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
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInset),
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInset),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInset)
        ])
    }
    
    // MARK: - Public methods
    
    func setData(taskTitle: String?,
                 projectTitle: String?,
                 timeSpent: String?
    ) {
        titleLabel.text = Constants.taskLabel + (taskTitle ?? "")
        projectLabel.text = Constants.projectLabel + (projectTitle ?? "")
        timeLabel.text = Constants.timeLabel + (timeSpent ?? "")
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonOnTap() {
        saveButtonAction?()
    }
}
