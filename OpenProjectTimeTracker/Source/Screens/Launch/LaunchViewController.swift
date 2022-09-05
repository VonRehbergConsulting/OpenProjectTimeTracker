//
//  LaunchViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation
import UIKit

protocol LaunchViewProtocol: AnyObject {}

final class LaunchViewController: UIViewController, LaunchViewProtocol {
    
    // MARK: - Properties
    
    var presenter: LaunchPresenterProtocol?
    
    var contentView: LaunchContentView? { view as? LaunchContentView }
    
    var finishFlow: ((Int?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = LaunchContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.contentView?.isControlEnabled = false
            self.checkAuthorization()
        }
        checkAuthorization()
    }
    
    // MARK: - Private helpers
    
    private func checkAuthorization() {
        presenter?.checkAuthorization() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .authorized:
                self.getUserID()
            case .unauthorized:
                self.finishFlow?(nil)
            case .unableToAccess:
                self.contentView?.isControlEnabled = true
            }
        }
    }
    
    private func getUserID() {
        presenter?.getUserID() { [weak self] userID in
            guard let self = self else { return }
            if let userID = userID {
                self.finishFlow?(userID)
            } else {
                self.contentView?.isControlEnabled = true
            }
        }
    }
}
