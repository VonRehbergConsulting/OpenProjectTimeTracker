//
//  TimerModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerModelProtocol {
    
    func updateTaskData(selfHref: String, projectHref: String)
}

final class TimerModel: TimerModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TimerPresenterProtocol?
    
    private let userID: Int
    private var taskHref = ""
    private var projectHref = ""
    
    // MARK: - Lifecycle
    
    init(userID: Int) {
        self.userID = userID
    }
    
    // MARK: - TimerModelProtocol
    
    func updateTaskData(selfHref: String, projectHref: String) {
        self.taskHref = selfHref
        self.projectHref = projectHref
    }
}
