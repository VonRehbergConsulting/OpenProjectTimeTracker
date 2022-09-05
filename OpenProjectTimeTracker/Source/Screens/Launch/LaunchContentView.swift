//
//  LaunchContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation
import UIKit

class LaunchContentView: UIView {
    
    // MARK: Constants
    
    private struct Constants {
        static let stackViewSpacing: CGFloat = 24
        static let edgeInset: CGFloat = 16
    }
    
    // MARK: - Subviews
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.alignment = .center
        
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(button)
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel().disableMask()
        label.text = "Connection error"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var button: DSSlimButton = {
        let button = DSSlimButton().disableMask()
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView().disableMask()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: - Properties
    
    var buttonAction: (() -> Void)?
    
    var isControlEnabled: Bool {
        get { !stackView.isHidden }
        set {
            stackView.isHidden = !newValue
            newValue ? spinner.stopAnimating() : spinner.startAnimating()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        addSubview(stackView)
        addSubview(spinner)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -Constants.edgeInset * 2),
            
            button.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            
            spinner.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func buttonPressed() {
        buttonAction?()
    }
}
