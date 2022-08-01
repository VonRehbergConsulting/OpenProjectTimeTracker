//
//  AuthorizationContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit

final class AuthorizationContentView: UIView {
    
    // MARK: - Subviews
    
    private lazy var loginButton: UIButton = {
        let button = UIButton().disableMask()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Properties
    
    var loginButtonAction: (() -> Void)?
    
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
        
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonPressed() {
        loginButtonAction?()
    }
}
