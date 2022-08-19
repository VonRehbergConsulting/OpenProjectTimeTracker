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
        static let stackViewSpacing: CGFloat = 20
        static let edgeInset: CGFloat = 16
        static let buttonInset: CGFloat = 44
        
        static let taskLabel = "Task"
        static let projectLabel = "Project"
        static let timeLabel = "Time spent"
        static let commentLabel = "Comment"
    }
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView().disableMask()
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(taskTextField)
        stackView.addArrangedSubview(projectTextField)
        stackView.addArrangedSubview(timeTextField)
        stackView.addArrangedSubview(commentTextField)
        return stackView
    }()
    
    private lazy var taskTextField: DSTextField = {
        let textField = DSTextField().disableMask()
        textField.caption = Constants.taskLabel
        textField.isEnabled = false
        return textField
    }()
    
    private lazy var projectTextField: DSTextField = {
        let textField = DSTextField().disableMask()
        textField.caption = Constants.projectLabel
        textField.isEnabled = false
        return textField
    }()
    
    private lazy var timeTextField: DSTextField = {
        let textField = DSTextField().disableMask()
        textField.caption = Constants.timeLabel
        textField.isEnabled = false
        return textField
    }()
    
    private lazy var commentTextField: DSTextField = {
        let textField = DSTextField().disableMask()
        textField.caption = Constants.commentLabel
        textField.shouldReturnHandler = { [weak self] in
            textField.resignFirstResponder()
        }
        return textField
    }()
    
    private lazy var saveButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var saveButtonAction: (() -> Void)?
    
    var comment: String? {
        get { commentTextField.text }
        set { commentTextField.text = newValue }
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
        backgroundColor = Colors.background
        addSubview(scrollView)
        addSubview(saveButton)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.edgeInset),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Constants.edgeInset * 2),
            
            saveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.edgeInset),
            saveButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Constants.edgeInset),
            saveButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Constants.edgeInset),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonInset)
        ])
    }
    
    // MARK: - Public methods
    
    func setData(taskTitle: String?,
                 projectTitle: String?,
                 timeSpent: String?,
                 comment: String?
    ) {
        taskTextField.text = taskTitle ?? ""
        projectTextField.text = projectTitle ?? ""
        timeTextField.text = timeSpent ?? ""
        commentTextField.text = comment
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonOnTap() {
        saveButtonAction?()
    }
}
