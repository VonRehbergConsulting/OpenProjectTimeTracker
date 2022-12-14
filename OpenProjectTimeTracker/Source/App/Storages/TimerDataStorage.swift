//
//  TimerDataStorage.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 11.08.22.
//

import Foundation

protocol TimerDataStorageProtocol: AnyObject {
    
    var userID: Int? { get set }
    var timeEntryID: Int? { get set }
    var task: Task? { get set }
    var startTime: Date? { get set }
    var stopTime: Date? { get set }
    var comment: String? { get set }
    
    func clearTaskData()
}

final class TimerDataStorage: TimerDataStorageProtocol {
    
    // MARK: - Properties
    
    private let userDefaultsProtocol: UserDefaultsProtocol
    
    private let userIDKey = "userID"
    private let timeEntryIDKey = "timeEntryID"
    private let taskKey = "currentTask"
    private let startTimeKey = "startTime"
    private let stopTimeKey = "stopTime"
    private let commentKey = "commentKey"
    
    // MARK: - Lifecycle
    
    init(userDefaultsProtocol: UserDefaultsProtocol) {
        self.userDefaultsProtocol = userDefaultsProtocol
    }
    
    // MARK: - TimerDataStorageProtocol
    
    var userID: Int? {
        get { object(forKey: userIDKey) as? Int }
        set { store(newValue, forKey: userIDKey) }
    }
    
    var timeEntryID: Int? {
        get { object(forKey: timeEntryIDKey) as? Int }
        set { store(newValue, forKey: timeEntryIDKey) }
    }
    
    var task: Task? {
        get {
            guard let data = object(forKey: taskKey) as? Data,
                  let task = try? JSONDecoder().decode(Task.self, from: data)
            else { return nil }
            return task
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            store(data, forKey: taskKey)
        }
    }
    
    var startTime: Date? {
        get { object(forKey: startTimeKey) as? Date }
        set { store(newValue, forKey: startTimeKey) }
    }
    
    var stopTime: Date? {
        get { object(forKey: stopTimeKey) as? Date }
        set { store(newValue, forKey: stopTimeKey) }
    }
    var comment: String? {
        get { object(forKey: commentKey) as? String }
        set { store(newValue, forKey: commentKey) }
    }
    
    func clearTaskData() {
        task = nil
        startTime = nil
        stopTime = nil
        timeEntryID = nil
        comment = nil
    }
    
    // MARK: - Private helpers
    
    private func store(_ value: Any?, forKey key: String) {
        userDefaultsProtocol.set(value, forKey: key)
    }
    
    private func object(forKey key: String) -> Any? {
        userDefaultsProtocol.object(forKey: key)
    }
}
