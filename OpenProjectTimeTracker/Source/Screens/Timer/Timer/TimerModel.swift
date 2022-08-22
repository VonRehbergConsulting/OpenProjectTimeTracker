//
//  TimerModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerModelProtocol {
    
    var task: Task? { get set }
    var isActive: Bool { get }
    var timeEntryID: Int? { get set }
    var comment: String? { get set }
    
    var startTime: Date? { get set }
    var stopTime: Date? { get set }
}

final class TimerModel: TimerModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TimerPresenterProtocol?
    
    private let userID: Int
    private let storage: TimerDataStorageProtocol
    
    // MARK: - Lifecycle
    
    init(userID: Int, storage: TimerDataStorageProtocol) {
        self.userID = userID
        self.storage = storage
        initialDataCheck()
    }
    
    // MARK: - TimerModelProtocol
    
    var isActive: Bool {
        guard startTime != nil else { return false }
        if stopTime == nil {
            return true
        } else {
            return false
        }
    }
    var task: Task? {
        get { storage.task }
        set { storage.task = newValue }
    }
    var startTime: Date? {
        get { storage.startTime }
        set { storage.startTime = newValue }
    }
    var stopTime: Date? {
        get { storage.stopTime }
        set { storage.stopTime = newValue }
    }
    var timeEntryID: Int? {
        get { storage.timeEntryID }
        set { storage.timeEntryID = newValue }
    }
    var comment: String? {
        get { storage.comment }
        set { storage.comment = newValue }
    }
    
    // MARK: - Private helpers
    
    private func initialDataCheck() {
        guard let startTime = startTime,
              task != nil
        else {
            storage.clear()
            return
        }
        let acceptableTimeInterval: TimeInterval = 36000
        let timeSinceStart = Date().timeIntervalSince(startTime)
        guard timeSinceStart < acceptableTimeInterval else {
            storage.clear()
            return
        }
    }
}
