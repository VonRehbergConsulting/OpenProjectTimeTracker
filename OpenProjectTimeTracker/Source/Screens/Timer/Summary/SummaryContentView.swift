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
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(timeTextFieldOnTap))
        textField.addGestureRecognizer(gestureRecognizer)
        return textField
    }()
    
    private lazy var commentTextField: DSTextField = {
        let textField = DSTextField().disableMask()
        textField.caption = Constants.commentLabel
        textField.shouldReturnHandler = { [weak self] in
            textField.resignFirstResponder()
        }
        textField.buttonImage = .actions
        return textField
    }()
    
    private lazy var saveButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var timePicker: DSTimePicker = {
        let picker = DSTimePicker().disableMask()
        picker.alpha = 0.0
        picker.valueChangedCompletion = { [weak self] in
            guard let self = self else { return }
            self.setTimeLabel(self.currentPickerTime)
        }
        return picker
    }()
    
    // MARK: - Properties
    
    var currentPickerTime: DateComponents {
        var components = DateComponents()
        components.hour = timePicker.hours
        components.minute = timePicker.minutes
        return components
    }
    
    var saveButtonAction: (() -> Void)?
    var commentSuggestionsAction: (() -> Void)? {
        get { commentTextField.buttonHandler }
        set { commentTextField.buttonHandler = newValue }
    }
    
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
                 timeSpent: DateComponents?,
                 comment: String?
    ) {
        taskTextField.text = taskTitle ?? ""
        projectTextField.text = projectTitle ?? ""
        if let timeSpent = timeSpent {
            setTimeLabel(timeSpent)
            let hours = timeSpent.hour ?? 0
            let minutes = timeSpent.minute ?? 0
            timePicker.selectRow(hours, inComponent: 0, animated: true)
            timePicker.selectRow(minutes, inComponent: 1, animated: true)
        } else {
            timeTextField.text = nil
        }
        commentTextField.text = comment
    }
    
    // MARK: - Actions
    
    @objc private func timeTextFieldOnTap() {
        let _ = commentTextField.resignFirstResponder()
        if stackView.subviews.contains(timePicker) {
            timePicker.removeFromSuperview()
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.layoutIfNeeded()
                self?.timePicker.alpha = 0.0
            })
        } else {
            timePicker.alpha = 0.0
            stackView.insertArrangedSubview(timePicker, at: 3)
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
            UIView.animate(withDuration: 0.2, delay: 0.1, animations: { [weak self] in
                self?.timePicker.alpha = 1.0
            })
        }
    }
    
    @objc private func saveButtonOnTap() {
        saveButtonAction?()
    }
    
    @objc  private func commentSuggestionsOnTap() {
        commentSuggestionsAction?()
    }
    
    // MARK: - Private helpers
    
    private func setTimeLabel(_ components: DateComponents) {
        timeTextField.text = components.shortClockTime
    }
}
