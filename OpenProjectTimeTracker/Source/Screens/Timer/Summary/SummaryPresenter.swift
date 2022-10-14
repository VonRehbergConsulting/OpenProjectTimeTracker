//
//  SummaryPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import Foundation

protocol SummaryPresenterProtocol: AnyObject {
    
    var taskTitle: String? { get }
    var projectTitle: String? { get }
    var timeSpent: DateComponents? { get set }
    var comment: String? { get set }
    
    var commentSuggestions: [String]? { get }
    
    func createTimeEntry(_ completion: @escaping (Bool) -> Void)
    func loadCommentSuggestions(_ completion: @escaping ((() -> Void)))
}

final class SummaryPresenter: SummaryPresenterProtocol {
    
    // MARK: Properties
    
    weak var view: SummaryViewProtocol?
    var model: SummaryModelProtocol?
    
    // MARK: - TimerPresenterProtocol
    
    var taskTitle: String? { model?.taskTitle }
    var projectTitle: String? { model?.projectTitle }
    var timeSpent: DateComponents? {
        get { model?.timeSpent }
        set {
            if let newValue = newValue { model?.timeSpent = newValue }
            else { Logger.log(event: .warning, "Trying to set empty element") }
        }
    }
    var comment: String? {
        get { model?.comment }
        set { model?.comment = newValue}
    }
    
    var commentSuggestions: [String]? { model?.commentSuggestions }
    
    func createTimeEntry(_ completion: @escaping (Bool) -> Void) {
        model?.saveTimeEntry(completion)
    }
    
    func loadCommentSuggestions(_ completion: @escaping ((() -> Void))) {
        model?.loadCommentSuggestions(completion)
    }
}
