//
//  SummaryModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import Foundation

protocol SummaryModelProtocol: AnyObject {
    
    var taskTitle: String? { get }
    var projectTitle: String? { get }
    var timeSpent: Date { get }
    var comment: String? { get set }
    
    func saveTimeEntry(_ completion: @escaping (Bool) -> Void)
}

final class SummaryModel: SummaryModelProtocol {
    
    // MARK: Properties
    
    weak var presenter: SummaryPresenterProtocol?
    
    private let service: TimeEntriesServiceProtocol
    private let timeEntryID: Int?
    private let userID: Int
    private let taskHref: String
    private let projectHref: String
    let timeSpent: Date
    var comment: String?
    
    let taskTitle: String?
    let projectTitle: String?
    
    // MARK: - Lifecycle
    
    init(service: TimeEntriesServiceProtocol,
         timeEntryID: Int?,
         userID: Int,
         taskHref: String,
         projectHref: String,
         timeSpent: Date,
         taskTitle: String?,
         projectTitle: String?,
         comment: String?) {
        self.timeEntryID = timeEntryID
        self.userID = userID
        self.service = service
        self.taskHref = taskHref
        self.projectHref = projectHref
        self.timeSpent = timeSpent
        self.taskTitle = taskTitle
        self.projectTitle = projectTitle
        self.comment = comment
    }
    
    // MARK: - SummaryModelProtocol
    
    func saveTimeEntry(_ completion: @escaping (Bool) -> Void) {
        if let timeEntryID = timeEntryID {
            updateTimeEntry(id: timeEntryID, completion)
        } else {
            createTimeEntry(completion)
        }
    }
    
    // MARK: - Private helpers
    
    private func createTimeEntry(_ completion: @escaping (Bool) -> Void) {
        service.create(userID: userID,
                       projectHref: projectHref,
                       workPackageHref: taskHref,
                       duration: timeSpent,
                       date: Date(),
                       comment: comment) { success in
            completion(success)
        }
    }
    
    private func updateTimeEntry(id: Int, _ completion: @escaping (Bool) -> Void) {
        service.update(id: id, duration: timeSpent, comment: comment, completion)
    }
}
