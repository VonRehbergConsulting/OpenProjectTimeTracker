//
//  TimerModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerModelProtocol {
    
    var state: TimerState { get set }
    
    var startTime: Date? { get set }
    var pauseTime: Date? { get set }
    var stopTime: Date? { get set }
    
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
    
    var state: TimerState = .taskNotSelected
    
    var startTime: Date?
    var pauseTime: Date?
    var stopTime: Date?
    
    func updateTaskData(selfHref: String, projectHref: String) {
        self.taskHref = selfHref
        self.projectHref = projectHref
    }
}
