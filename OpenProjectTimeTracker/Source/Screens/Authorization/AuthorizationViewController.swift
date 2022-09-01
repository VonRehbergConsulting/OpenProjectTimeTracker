//
//  AuthorizationViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit
import OAuthSwift

protocol AuthorizationViewProrocol: AnyObject {
    
}

final class AuthorizationViewController: UIViewController, AuthorizationViewProrocol {
    
    // MARK: - Properties
    
    var contentView: AuthorizationContentView? { view as? AuthorizationContentView }
    
    var presenter: AuthorizationPresenterProtocol?
    
    var finishFlow: ((Int) -> Void)?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = AuthorizationContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView?.loginButtonAction = { [weak self] in
            guard let self = self,
                let presenter = self.presenter
            else { return }
            presenter.authorize() { [weak self] userID in
                guard let self = self else { return }
                if let userID = userID {
                    self.finishFlow?(userID)
                } else {
                    self.showAlert(title: "Authorization error", message: "Please, try again later")
                }
            }
        }   
    }
}
