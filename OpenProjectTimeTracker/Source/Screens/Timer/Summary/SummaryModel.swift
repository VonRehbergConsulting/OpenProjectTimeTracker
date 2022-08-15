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
    
    func createTimeEntry(_ completion: @escaping (Bool) -> Void)
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
         projectTitle: String?) {
        self.timeEntryID = timeEntryID
        self.userID = userID
        self.service = service
        self.taskHref = taskHref
        self.projectHref = projectHref
        self.timeSpent = timeSpent
        self.taskTitle = taskTitle
        self.projectTitle = projectTitle
    }
    
    // MARK: - SummaryModelProtocol
    
    func createTimeEntry(_ completion: @escaping (Bool) -> Void) {
        service.create(userID: userID,
                       projectHref: projectHref,
                       workPackageHref: taskHref,
                       duration: timeSpent,
                       date: Date(),
                       comment: comment) { success in
            completion(success)
        }
    }
}
