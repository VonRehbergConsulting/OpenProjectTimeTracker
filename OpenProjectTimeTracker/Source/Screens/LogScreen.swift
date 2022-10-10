//
//  LogScreen.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.10.22.
//

import UIKit

final class LogScreen: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let edgeInset: CGFloat = 8
        static let buttonInset: CGFloat = 8
    }
    
    // MARK: - Subviews
    
    private lazy var textView: UITextView = {
        let textView = UITextView().disableMask()
        textView.isEditable = false
        return textView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton().disableMask()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setData()
    }
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.buttonInset),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.buttonInset),
            
            textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.edgeInset),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.edgeInset),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.edgeInset),
        ])
    }
    
    private func setData() {
        textView.text = "";
        for entry in Logger.log {
            textView.text.append(entry + "\n")
        }
    }
    
    // MARK: - Actions
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
}
