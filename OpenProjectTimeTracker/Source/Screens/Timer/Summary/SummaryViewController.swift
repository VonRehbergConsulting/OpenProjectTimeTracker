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
    
    weak var coordinator: TimerCoordinatorProtocol?
    var presenter: SummaryPresenterProtocol?
    
    var finishFlow: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = SummaryContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.loadCommentSuggestions() { [weak self] in
            if let commentSuggestions = self?.presenter?.commentSuggestions,
               !commentSuggestions.isEmpty {
                self?.contentView?.showCommentSuggestionsButton()
            }
        }
        
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
            guard let self = self,
                  let items = self.presenter?.commentSuggestions,
                  !items.isEmpty
            else { return }
            self.coordinator?.routeToCommentSuggestions(items: items) { [weak self] comment in
                guard let self = self,
                      comment != nil
                else { return }
                self.presenter?.comment = comment
                self.contentView?.comment = comment
            }
        }
    }
}
