//
//  SummaryViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import UIKit

protocol SummaryViewProtocol: AnyObject {
    
}

final class SummaryViewController: UIViewController, SummaryViewProtocol {
    
    // MARK: Properties
    
    var contentView: SummaryContentView? { view as? SummaryContentView }
    
    var presenter: SummaryPresenterProtocol?
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = SummaryContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Overview"
        contentView?.setData(taskTitle: presenter?.taskTitle,
                             projectTitle: presenter?.projectTitle,
                             timeSpent: presenter?.timeSpent)
        
        contentView?.saveButtonAction = { [weak self] in
            guard let self = self else { return }
            // TODO: Inplement failure route
            self.presenter?.comment = self.contentView?.comment
            self.presenter?.createTimeEntry() { success in
                if success {
                    self.showAlert(title: "Your work has been logged", message: nil, { self.finishFlow?() })
                } else {
                    Logger.log(event: .error, "Can't save time entry!")
                }
            }
        }
    }
}
