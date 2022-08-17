//
//  AuthorizationContentView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit

class AuthorizationContentView: UIView {
    
    // MARK: - Subviews
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView().disableMask()
        imageView.image = UIImage(named: "openProjectLogo")
        return imageView
    }()
    
    private lazy var loginButton: DSButton = {
        let button = DSButton().disableMask()
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var loginButtonAction: (() -> Void)?
    var isLoginButtonEnabled: Bool {
        get { loginButton.isEnabled }
        set { loginButton.isEnabled = newValue }
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
        
        addSubview(logoImageView)
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -120),
            loginButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonPressed() {
        loginButtonAction?()
    }
}
