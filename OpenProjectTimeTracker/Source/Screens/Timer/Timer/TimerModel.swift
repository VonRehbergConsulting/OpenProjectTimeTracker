//
//  TimerModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerModelProtocol {
    
    var task: Task? { get set }
    var state: TimerState { get set }
    
    var startTime: Date? { get set }
    var stopTime: Date? { get set }
}

final class TimerModel: TimerModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TimerPresenterProtocol?
    
    private let userID: Int
    
    // MARK: - Lifecycle
    
    init(userID: Int) {
        self.userID = userID
    }
    
    // MARK: - TimerModelProtocol
    
    var task: Task? {
        didSet {
            state = task == nil ? .taskNotSelected : .setUp
            startTime = nil
            stopTime = nil
        }
    }
    var state: TimerState = .taskNotSelected
    
    var startTime: Date?
    var stopTime: Date?
}
