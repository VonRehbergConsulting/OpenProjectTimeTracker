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
                             timeSpent: presenter?.timeSpent,
                             comment: presenter?.comment
        )
        
        contentView?.saveButtonAction = { [weak self] in
            guard let self = self else { return }
            self.presenter?.comment = self.contentView?.comment
            self.presenter?.timeSpent = self.contentView?.currentPickerTime
            self.presenter?.createTimeEntry() { success in
                if success {
                    self.showAlert(title: "Your work has been logged", message: nil, { self.finishFlow?() })
                } else {
                    self.showAlert(title: "Error", message: "Can't log work")
                }
            }
        }
        contentView?.commentSuggestionsAction = { [weak self] in
            guard let self = self else { return }
            let viewController = CommentSuggestionViewController()
            viewController.finishFlow = { [weak self] comment in
                guard let self = self else { return }
                self.presenter?.comment = comment
                self.contentView?.comment = comment
            }
            viewController.items = ["Comment 1", "Another comment"]
            self.present(viewController, animated: true)
        }
    }
}
