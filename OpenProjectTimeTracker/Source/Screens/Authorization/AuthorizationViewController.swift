//
//  AuthorizationViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit
import OAuthSwift

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Properties
    
    var contentView: AuthorizationContentView? { view as? AuthorizationContentView }
    
    var authorizationService: AuthorizationServiceProtocol?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = AuthorizationContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView?.loginButtonAction = { [weak self] in
            self?.authorizationService?.authorize { [weak self] result in
                switch result {
                case .success(let token):
                    Logger.log("OAuth token: " + token.oauthToken)
                    Logger.log("Refresh token: " + token.refreshToken)
                case .failure(_):
                    self?.showAlert(title: "Authorization error", message: "Please, try again later")
                }
            }
        }   
    }
    
    // MARK: - Private helpers
    
    
}
