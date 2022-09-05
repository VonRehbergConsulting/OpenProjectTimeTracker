//
//  TimerDataStorageMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import Foundation

final class TimerDataStorageMock: TimerDataStorageProtocol {
    
    var userID: Int?
    var timeEntryID: Int?
    var task: Task?
    var startTime: Date?
    var stopTime: Date?
    var comment: String?
    
    var clearStub: (() -> Void)?
    func clearTaskData() {
        clearStub?()
    }
}
